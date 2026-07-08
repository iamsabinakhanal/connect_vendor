class ChatMessage {
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.createdAt,
    this.status = 'delivered',
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String? ?? '',
      isMe: map['isMe'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      status: map['status'] as String? ?? 'delivered',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isMe': isMe,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  final String text;
  final bool isMe;
  final DateTime createdAt;
  String status;
}
