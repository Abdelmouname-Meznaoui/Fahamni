import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { academic,system }

class NotificationModel {
  final String title;
  final String content;
  final DateTime dateTime;
  bool isRead;
  final String notificationId;
  final String receiverId;
  NotificationType type;

  NotificationModel({
    required this.title,
    required this.content,
    required this.dateTime,
    required this.isRead,
    required this.notificationId,
    required this.receiverId,
    required this.type,
  });

  /// from map transormf a map to dart object
  factory NotificationModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    print("Available keys in Firebase doc: ${map.keys.toList()}");

    return NotificationModel(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      dateTime: map['date_time'] != null
          ? (map['date_time'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: map['is_read'] ?? false,
      notificationId: map['notification_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      type: NotificationType.values.byName(map['type'] ?? 'academic'),
    );
  }

  /// to tranform dart object to map or firebase document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date_time': Timestamp.fromDate(dateTime),
      'is_read': isRead,
      'notification_id': notificationId,
      'receiver_id': receiverId,
      'type': type,
    };
  }
}