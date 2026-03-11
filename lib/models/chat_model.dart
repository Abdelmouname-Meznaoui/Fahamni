class ConversationModel {
  final String conversationName;
  final String conversationId;

  final List<String> participants;
  final List<MessageModel> messages;
  final DateTime createdAt;
  final String status;

  ConversationModel({
    required this.conversationId,
    required this.conversationName,
    required this.messages,
    required this.participants,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversation_name': conversationName,
      'conversation_id': conversationId,
      'participants': participants,
      'createdAt': createdAt,
      'status': status,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      conversationName: map['conversation_name'] ?? '',
      conversationId: map['conversation_id'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      messages: List<MessageModel>.from(
        (map['messages'] as List<dynamic>? ?? []).map(
          (x) => MessageModel.fromMap(x),
        ),
      ),
      createdAt: (map['createdAt'] as dynamic).toDate(),
      status: map['status'] ?? 'active',
    );
  }
}

class MessageModel {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime sendingDateTime;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.sendingDateTime,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'sending_date_time': sendingDateTime,
      'is_read': isRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['message_id'] ?? '',
      conversationId: map['conversation_id'] ?? '', //
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      content: map['content'] ?? '',
      sendingDateTime: (map['sending_date_time'] as dynamic).toDate(), //
      isRead: map['is_read'] ?? false, //
    );
  }
}
