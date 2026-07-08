import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../models/demo_chat.dart';
import '../models/chat_message.dart';

class ConversationView extends StatefulWidget {
  final DemoChat activeChat;
  final List<ChatMessage> messages;
  final TextEditingController chatController;
  final Function(String) onSendMessage;
  final VoidCallback onBackPressed;

  const ConversationView({
    super.key,
    required this.activeChat,
    required this.messages,
    required this.chatController,
    required this.onSendMessage,
    required this.onBackPressed,
  });

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Column(
        children: [
          // Header
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBackPressed,
                  icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: widget.activeChat.color,
                  child: Text(
                    widget.activeChat.name.isNotEmpty
                        ? widget.activeChat.name[0]
                        : 'U',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.activeChat.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final ChatMessage message = widget.messages[index];
                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    constraints: BoxConstraints(maxWidth: 270),
                    decoration: BoxDecoration(
                      color: message.isMe ? AppTheme.primary : AppTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatMessageTime(message.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            if (message.isMe) ...[
                              SizedBox(width: 4),
                              Icon(
                                message.status == 'seen'
                                    ? Icons.done_all
                                    : Icons.done,
                                size: 14,
                                color: message.status == 'seen'
                                    ? AppTheme.primarySoft
                                    : AppTheme.textSecondary,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field
          Container(
            color: AppTheme.surface,
            padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showActionMessage('Attachment tapped'),
                  icon: Icon(Icons.attach_file, color: AppTheme.textSecondary),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceAlt,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: widget.chatController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final String message = widget.chatController.text.trim();
    if (message.isEmpty) {
      _showActionMessage('Type a message first');
      return;
    }

    widget.onSendMessage(message);
    widget.chatController.clear();
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
