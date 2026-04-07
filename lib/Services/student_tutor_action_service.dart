import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/chat_service.dart';
import '../Services/notification_service.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../models/service_model.dart';
import '../models/student_model.dart';
import '../models/tutor_model.dart';
import '../repositories/firestore_chat_repository.dart';

class StudentTutorActionService {
  StudentTutorActionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    ChatService? chatService,
    NotificationService? notificationService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _chatService =
            chatService ?? ChatService(FirestoreChatRepository(firestore: firestore)),
        _notificationService = notificationService ?? NotificationService();

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ChatService _chatService;
  final NotificationService _notificationService;

  Future<StudentModel> getCurrentStudent() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You need to be signed in first.');
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('students').doc(currentUser.uid).get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Student profile not found.');
    }

    return StudentModel.fromMap({
      ...snapshot.data()!,
      'uid': snapshot.id,
    });
  }

  Future<bool> isFavoriteTutor(String tutorId) async {
    final StudentModel student = await getCurrentStudent();
    return student.favoriteTeachers.contains(tutorId);
  }

  Future<bool> toggleFavoriteTutor(String tutorId) async {
    final StudentModel student = await getCurrentStudent();
    final bool isFavorite = student.favoriteTeachers.contains(tutorId);

    await _firestore.collection('students').doc(student.uid).set(
      <String, dynamic>{
        'favorite_teachers': isFavorite
            ? FieldValue.arrayRemove(<String>[tutorId])
            : FieldValue.arrayUnion(<String>[tutorId]),
      },
      SetOptions(merge: true),
    );

    return !isFavorite;
  }

  Future<void> createBookingRequest({
    required TutorModel tutor,
    ServiceModel? service,
  }) async {
    final StudentModel student = await getCurrentStudent();
    final DocumentReference<Map<String, dynamic>> quoteRef =
        _firestore.collection('quotes').doc();

    await quoteRef.set({
      'quote_id': quoteRef.id,
      'student_id': student.uid,
      'tutor_id': tutor.uid,
      'subject': service?.subject ?? tutor.expertiseDomain,
      'level': service?.level ?? student.schoolLevel,
      'objective': service?.name.isNotEmpty == true
          ? 'Book session for ${service!.name}'
          : 'Book a session with ${tutor.firstName} ${tutor.lastName}',
      'frequency': 'To be discussed',
      'duration': service != null ? '${service.duration} min' : '60 min',
      'budget': service != null ? '${service.price.toInt()} DA' : 'To be discussed',
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });

    await _notificationService.sendNotification(
      NotificationModel(
        title: 'New booking request',
        content: '${student.firstName} sent a booking request${service != null ? ' for ${service.name}' : ''}.',
        dateTime: DateTime.now(),
        isRead: false,
        notificationId: '',
        receiverId: tutor.uid,
        type: 'quote_request',
        senderId: student.uid,
        tutorId: tutor.uid,
        serviceId: service?.serviceId ?? '',
      ),
    );
  }

  Future<ConversationModel> createOrGetConversation({
    required TutorModel tutor,
  }) async {
    final StudentModel student = await getCurrentStudent();
    final ConversationModel conversation = await _chatService.ensureDirectConversation(
      currentUserId: student.uid,
      otherUserId: tutor.uid,
    );

    return conversation.copyWith(
      conversationName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantDisplayName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantAvatarUrl: tutor.picture,
      participantSubtitle: tutor.expertiseDomain,
      isVerified: tutor.Certified,
      isOnline: tutor.isAvailable,
    );
  }
}
