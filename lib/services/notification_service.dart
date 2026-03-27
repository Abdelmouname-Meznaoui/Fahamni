import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificatinService {
  final firestore = FirebaseFirestore.instance;


  //CREATE
  Future<void> sendNotification(NotificationModel notification) async {
    try {

      await firestore
          .collection('notifications')
          .doc(notification.notificationId)
          .set(notification.toMap());
    } catch (e) {
      print("Firestore Error : $e");
      rethrow;
    }
  }

  //READ
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return firestore
        .collection('notifications')
        .where('receiver_id', isEqualTo: userId)
        .orderBy('date_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data()))
        .toList());
  }

  //UPDATE
  Future<void> markAsRead(String docId) async {
    try {
      await firestore.collection('notifications').doc(docId).update({
        'is_read': true,
      });
    } catch (e) {
      print("Firestore Error : $e");
      rethrow;
    }
  }
  // DELETE
  Future<void> deleteNotification(String docId) async {
    try {
      await firestore.collection('notifications').doc(docId).delete();
    } catch (e) {
      print("Firestore Error : $e");
      rethrow;
    }
  }
}