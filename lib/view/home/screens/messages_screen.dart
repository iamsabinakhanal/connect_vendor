import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/local_database.dart';
import '../models/demo_chat.dart';
import '../models/chat_message.dart';
import '../widgets/chat_tile.dart';
import '../widgets/conversation_view.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  static const String _chatHistoryKey = 'demo_chat_history_v1';
  int _activeChatIndex = -1;
  late TextEditingController _chatController;
  late Map<int, List<ChatMessage>> _chatMessages;

  final List<DemoChat> _demoChats = [
    DemoChat(
      name: 'Sabitra Khanal',
      lastMessage: 'Did you check today\'s offers?',
      time: '10:24 AM',
      unread: 2,
      color: Color(0xFF60A5FA),
    ),
    DemoChat(
      name: 'Kirty Dhakal',
      lastMessage: 'Let\'s post your product reel today.',
      time: '9:11 AM',
      unread: 0,
      color: Color(0xFFF472B6),
    ),
    DemoChat(
      name: 'Vendor Community',
      lastMessage: '12 new messages',
      time: 'Yesterday',
      unread: 12,
      color: Color(0xFF34D399),
    ),
    DemoChat(
      name: 'TechVendor Pro',
      lastMessage: 'Thanks for sharing the catalog.',
      time: 'Yesterday',
      unread: 0,
      color: Color(0xFFA78BFA),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _chatController = TextEditingController();
    _chatMessages = {
      0: [
        ChatMessage(
          text: 'Namaste! Have you seen new offers?',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(minutes: 35)),
        ),
        ChatMessage(
          text: 'Not yet, I will check now.',
          isMe: true,
          createdAt: DateTime.now().subtract(Duration(minutes: 34)),
          status: 'seen',
        ),
      ],
      1: [
        ChatMessage(
          text: 'Let\'s post your product reel today.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(minutes: 50)),
        ),
      ],
      2: [
        ChatMessage(
          text: 'Welcome to Vendor Community.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        ChatMessage(
          text: 'Thank you everyone!',
          isMe: true,
          createdAt: DateTime.now().subtract(Duration(hours: 2, minutes: 1)),
          status: 'seen',
        ),
      ],
      3: [
        ChatMessage(
          text: 'Thanks for sharing the catalog.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
        ),
      ],
    };
    _loadChatHistory();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeChatIndex >= 0) {
      return _buildConversationView();
    }

    return Container(
      color: AppTheme.background,
      child: Column(
        children: [
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showActionMessage('Search chats tapped'),
                  icon: Icon(Icons.search, color: AppTheme.textPrimary),
                ),
                IconButton(
                  onPressed: () => _showActionMessage('New chat tapped'),
                  icon: Icon(Icons.chat, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search or start new chat',
                prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                filled: true,
                fillColor: AppTheme.surfaceAlt,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < _demoChats.length; i++)
                  ChatTile(
                    chat: _demoChats[i],
                    index: i,
                    onTap: () {
                      setState(() {
                        _activeChatIndex = i;
                        _demoChats[i].unread = 0;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationView() {
    final DemoChat activeChat = _demoChats[_activeChatIndex];
    final List<ChatMessage> messages = _chatMessages[_activeChatIndex] ?? [];

    return ConversationView(
      activeChat: activeChat,
      messages: messages,
      chatController: _chatController,
      onSendMessage: _sendDemoMessage,
      onBackPressed: () {
        setState(() {
          _activeChatIndex = -1;
        });
      },
    );
  }

  void _sendDemoMessage(String message) {
    if (_activeChatIndex < 0) {
      _showActionMessage('Open a chat first');
      return;
    }

    setState(() {
      _chatMessages[_activeChatIndex] ??= [];
      _chatMessages[_activeChatIndex]!.add(
        ChatMessage(
          text: message,
          isMe: true,
          createdAt: DateTime.now(),
          status: 'delivered',
        ),
      );
      _demoChats[_activeChatIndex].lastMessage = message;
      _demoChats[_activeChatIndex].time = _currentTimeLabel();
    });
    _saveChatHistory();

    Future.delayed(Duration(milliseconds: 700), () {
      if (!mounted || _activeChatIndex < 0) return;
      setState(() {
        final List<ChatMessage> chat = _chatMessages[_activeChatIndex]!;
        for (int i = chat.length - 1; i >= 0; i--) {
          if (chat[i].isMe) {
            chat[i].status = 'seen';
            break;
          }
        }
        _chatMessages[_activeChatIndex]!.add(
          ChatMessage(
            text: 'Got it. I will reply soon.',
            isMe: false,
            createdAt: DateTime.now(),
          ),
        );
        _demoChats[_activeChatIndex].lastMessage = 'Got it. I will reply soon.';
        _demoChats[_activeChatIndex].time = _currentTimeLabel();
      });
      _saveChatHistory();
    });
  }

  String _currentTimeLabel() {
    return TimeOfDay.now().format(context);
  }

  Future<void> _loadChatHistory() async {
    final box = LocalDatabase.chatBox();
    final String? raw = box.get(_chatHistoryKey) as String?;
    if (raw == null || raw.isEmpty) return;

    try {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      final Map<int, List<ChatMessage>> loaded = {};

      decoded.forEach((key, value) {
        final int chatIndex = int.tryParse(key) ?? -1;
        if (chatIndex < 0 || value is! List) return;
        loaded[chatIndex] = value
            .whereType<Map>()
            .map((e) => ChatMessage.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      });

      if (!mounted) return;
      setState(() {
        _chatMessages = loaded.isNotEmpty ? loaded : _chatMessages;
        for (int i = 0; i < _demoChats.length; i++) {
          final List<ChatMessage>? chat = _chatMessages[i];
          if (chat == null || chat.isEmpty) continue;
          final ChatMessage last = chat.last;
          _demoChats[i].lastMessage = last.text;
          _demoChats[i].time = _formatMessageTime(last.createdAt);
        }
      });
    } catch (_) {
      // Keep default demo data if saved payload is malformed.
    }
  }

  Future<void> _saveChatHistory() async {
    final box = LocalDatabase.chatBox();
    final Map<String, dynamic> payload = {};
    _chatMessages.forEach((key, value) {
      payload[key.toString()] = value.map((m) => m.toMap()).toList();
    });
    await box.put(_chatHistoryKey, jsonEncode(payload));
  }

  String _formatMessageTime(DateTime time) {
    final TimeOfDay tod = TimeOfDay.fromDateTime(time);
    return tod.format(context);
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
