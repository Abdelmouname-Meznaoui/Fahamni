import 'package:intl/intl.dart'; // Add this to your pubspec.yaml for date formatting

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

  // --- GETTERS FOR UI ---
  
  // Gets the last message safely
  
  MessageModel? get _lastMessage => messages.isNotEmpty ? messages.last : null;
// Inside your ConversationModel class
  String get lastSenderName {
  if (messages.isEmpty) return "No messages";
  
  // Logic: If the senderId is mine, return "You", otherwise return the conversation name
  // Note: You'll need to pass your own userId to this logic or handle it in the UI
  return messages.last.senderId; 
   }
  String get lastMessageText => _lastMessage?.content ?? "No messages yet";

  String get lastMessageTime {
    if (_lastMessage == null) return "";
    // Returns 10:30 AM format
    return DateFormat.jm().format(_lastMessage!.sendingDateTime);
  }

  int get unreadCount => messages.where((m) => !m.isRead).length;

  // --- DATA METHODS ---

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
      messages: (map['messages'] as List<dynamic>?)
              ?.map((x) => MessageModel.fromMap(x as Map<String, dynamic>))
              .toList() ?? [],
      createdAt: map['createdAt'] is DateTime 
          ? map['createdAt'] 
          : (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
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

  // Helper to create a new instance with updated fields
  MessageModel copyWith({bool? isRead}) {
    return MessageModel(
      messageId: messageId,
      conversationId: conversationId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      sendingDateTime: sendingDateTime,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'sending_date_time': sendingDateTime, // Firestore handles DateTime directly
      'is_read': isRead,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['message_id'] ?? '',
      conversationId: map['conversation_id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      content: map['content'] ?? '',
      // Safely handle both DateTime and Firestore Timestamp
      sendingDateTime: map['sending_date_time'] is DateTime 
          ? map['sending_date_time'] 
          : (map['sending_date_time'] as dynamic)?.toDate() ?? DateTime.now(),
      isRead: map['is_read'] ?? false,
    );
  }
}