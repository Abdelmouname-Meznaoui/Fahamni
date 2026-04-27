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
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _chatService =
           chatService ??
           ChatService(FirestoreChatRepository(firestore: firestore)),
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

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('students')
        .doc(currentUser.uid)
        .get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Student profile not found.');
    }

    return StudentModel.fromMap(<String, dynamic>{
      ...snapshot.data()!,
      'uid': snapshot.data()?['uid'] ?? snapshot.id,
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
    String? studentId,
  }) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You need to be signed in first.');
    }

    final String role = await _loadCurrentRole(currentUser.uid);
    final StudentModel student = await _resolveQuoteStudent(
      role: role,
      selectedStudentId: studentId,
    );

    if (service != null) {
      final DocumentReference<Map<String, dynamic>> serviceRef = _firestore
          .collection('services')
          .doc(service.serviceId);

      await _firestore.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> serviceSnap =
            await transaction.get(serviceRef);
        if (!serviceSnap.exists) return;

        final List<String> pendingIds = List<String>.from(
          serviceSnap.data()?['pending_ids'] ?? [],
        );
        final List<String> studentIds = List<String>.from(
          serviceSnap.data()?['student_ids'] ?? [],
        );

        if (!pendingIds.contains(student.uid) &&
            !studentIds.contains(student.uid)) {
          pendingIds.add(student.uid);
          final int enrolledNum =
              (serviceSnap.data()?['enrolled_num'] ?? 0) + 1;

          transaction.update(serviceRef, {
            'pending_ids': pendingIds,
            'enrolled_num': enrolledNum,
          });
        }
      });
    }

    final DocumentReference<Map<String, dynamic>> quoteRef = _firestore
        .collection('quotes')
        .doc();

    await quoteRef.set({
      'quote_id': quoteRef.id,
      'student_id': student.uid,
      'tutor_id': tutor.uid,
      'service_id': service?.serviceId ?? '',
      'subject': service?.subject ?? tutor.expertiseDomain,
      'level': service?.level ?? student.schoolLevel,
      'objective': service?.name.isNotEmpty == true
          ? 'Quote request for ${service!.name}'
          : 'Quote request with ${tutor.firstName} ${tutor.lastName}',
      'frequency': 'To be discussed',
      'duration': service != null ? '${service.duration} min' : '60 min',
      'budget': service != null
          ? '${service.price.toInt()} DA'
          : 'To be discussed',
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });

    await _notificationService.sendNotification(
      NotificationModel(
        title: 'New booking request',
        content:
            '${student.firstName} sent a booking request${service != null ? ' for ${service.name}' : ''}.',
        dateTime: DateTime.now(),
        isRead: false,
        notificationId: '',
        receiverId: tutor.uid,
        type: 'quote_request',
        senderId: currentUser.uid,
        tutorId: tutor.uid,
        serviceId: service?.serviceId ?? '',
      ),
    );
  }

  Future<ConversationModel> createOrGetConversation({
    required TutorModel tutor,
  }) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You need to be signed in first.');
    }

    final ConversationModel conversation = await _chatService
        .ensureDirectConversation(
          currentUserId: currentUser.uid,
          otherUserId: tutor.uid,
        );

    return conversation.copyWith(
      conversationName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantDisplayName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantAvatarUrl: tutor.picture,
      participantSubtitle: tutor.expertiseDomain,
      isVerified: tutor.certified,
      isOnline: tutor.isAvailable,
    );
  }

  Future<List<StudentModel>> getCurrentParentChildren() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You need to be signed in first.');
    }

    final DocumentSnapshot<Map<String, dynamic>> parentDoc = await _firestore
        .collection('parents')
        .doc(currentUser.uid)
        .get();
    if (!parentDoc.exists || parentDoc.data() == null) {
      return <StudentModel>[];
    }

    final List<String> childrenUids = List<String>.from(
      parentDoc.data()?['children_uids'] ?? const <String>[],
    );
    if (childrenUids.isEmpty) {
      return <StudentModel>[];
    }

    final List<DocumentSnapshot<Map<String, dynamic>>> childDocs =
        await Future.wait(
          childrenUids
              .where((id) => id.trim().isNotEmpty)
              .toSet()
              .map((id) => _firestore.collection('students').doc(id).get()),
        );

    return childDocs
        .where((doc) => doc.exists && doc.data() != null)
        .map(
          (doc) => StudentModel.fromMap(<String, dynamic>{
            ...doc.data()!,
            'uid': doc.data()?['uid'] ?? doc.id,
          }),
        )
        .toList();
  }

  Future<String> _loadCurrentRole(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(uid)
        .get();
    return ((userDoc.data()?['role'] as String?) ?? 'student').toLowerCase();
  }

  Future<StudentModel> _resolveQuoteStudent({
    required String role,
    String? selectedStudentId,
  }) async {
    if (role != 'parent') {
      return getCurrentStudent();
    }

    final List<StudentModel> children = await getCurrentParentChildren();
    if (children.isEmpty) {
      throw Exception('No child linked to your account.');
    }

    if (selectedStudentId != null && selectedStudentId.trim().isNotEmpty) {
      final String targetId = selectedStudentId.trim();
      final StudentModel? selected = children.cast<StudentModel?>().firstWhere(
        (child) => child?.uid == targetId,
        orElse: () => null,
      );
      if (selected == null) {
        throw Exception('Selected child account was not found.');
      }
      return selected;
    }

    return children.first;
  }
}
