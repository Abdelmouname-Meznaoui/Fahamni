import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Services/chat_service.dart';
import '../Services/notification_service.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../models/parent_model.dart';
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

  User _requireSignedInUser() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('You need to be signed in first.');
    }
    return currentUser;
  }

  Future<StudentModel> getCurrentStudent() async {
    final User currentUser = _requireSignedInUser();

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('students')
        .doc(currentUser.uid)
        .get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Student profile not found.');
    }

    return StudentModel.fromMap({...snapshot.data()!, 'uid': snapshot.id});
  }

  Future<StudentModel?> getStudentDataById(String id) async {
    final String studentId = id.trim();
    if (studentId.isEmpty) {
      return null;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('students')
        .doc(studentId)
        .get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return StudentModel.fromMap({...snapshot.data()!, 'uid': snapshot.id});
  }

  Future<ParentModel> getCurrentParent() async {
    final User currentUser = _requireSignedInUser();

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('parents')
        .doc(currentUser.uid)
        .get();
    if (!snapshot.exists || snapshot.data() == null) {
      throw Exception('Parent profile not found.');
    }

    return ParentModel.fromMap({...snapshot.data()!, 'uid': snapshot.id});
  }

  Future<String> getCurrentUserRole() async {
    final User currentUser = _requireSignedInUser();

    final DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final String role = (userSnapshot.data()?['role'] as String?)?.trim() ?? '';
    if (role == 'student' || role == 'parent' || role == 'tutor') {
      return role;
    }

    final DocumentSnapshot<Map<String, dynamic>> parentSnapshot =
        await _firestore.collection('parents').doc(currentUser.uid).get();
    if (parentSnapshot.exists) {
      return 'parent';
    }

    final DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
        await _firestore.collection('students').doc(currentUser.uid).get();
    if (studentSnapshot.exists) {
      return 'student';
    }

    return 'student';
  }

  Future<List<StudentModel>> getLinkedChildrenForCurrentParent() async {
    final ParentModel parent = await getCurrentParent();
    final List<String> childIds = parent.childrenUids
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (childIds.isEmpty) {
      return <StudentModel>[];
    }

    final List<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        await Future.wait(
          childIds.map((id) => _firestore.collection('students').doc(id).get()),
        );

    final List<StudentModel> children = snapshots
        .where((snapshot) => snapshot.exists && snapshot.data() != null)
        .map(
          (snapshot) =>
              StudentModel.fromMap({...snapshot.data()!, 'uid': snapshot.id}),
        )
        .toList();

    children.sort((a, b) {
      final String aName = '${a.firstName} ${a.lastName}'.trim().toLowerCase();
      final String bName = '${b.firstName} ${b.lastName}'.trim().toLowerCase();
      return aName.compareTo(bName);
    });
    return children;
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
    String? childStudentId,
  }) async {
    final _ActionActor actor = await _resolveActionActor(
      childStudentId: childStudentId,
    );
    final StudentModel student = actor.student;

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
    final Timestamp now = Timestamp.now();

    final Map<String, dynamic> quoteData = {
      'quote_id': quoteRef.id,
      'student_id': student.uid,
      'tutor_id': tutor.uid,
      'service_id': service?.serviceId ?? '',
      'service_name': service?.name ?? '',
      'subject': service?.subject ?? tutor.expertiseDomain,
      'level': service?.level ?? student.schoolLevel,
      'objective': service?.name.isNotEmpty == true
          ? 'Join request for ${service!.name}'
          : 'Join request for ${tutor.firstName} ${tutor.lastName}'.trim(),
      'description': '',
      'teaching_mode': service?.mode ?? tutor.teachingMode,
      'sessions_count': service?.sessionsnum ?? 0,
      'frequency': 'To be discussed',
      'duration': service != null ? '${service.duration} min' : '60 min',
      'budget': service != null
          ? '${service.price.toInt()} DA'
          : 'To be discussed',
      'status': 'pending',
      'request_by': actor.role,
      'created_at': now,
      'createdAt': now,
    };
    if (actor.role == 'parent') {
      quoteData['parent_id'] = actor.actorId;
    }

    await quoteRef.set(quoteData);

    await _notificationService.sendNotification(
      NotificationModel(
        title: 'New join request',
        content:
            '${student.firstName} sent a join request${service != null ? ' for ${service.name}' : ''}.',
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

  Future<void> submitQuoteRequest({
    required TutorModel tutor,
    required String subject,
    required String description,
    required String teachingMode,
    required int sessionsCount,
    required int sessionDurationMinutes,
    ServiceModel? service,
    String? childStudentId,
  }) async {
    final _ActionActor actor = await _resolveActionActor(
      childStudentId: childStudentId,
    );
    final StudentModel student = actor.student;
    final DocumentReference<Map<String, dynamic>> quoteRef = _firestore
        .collection('quotes')
        .doc();
    final Timestamp now = Timestamp.now();
    final String normalizedDescription = description.trim();
    final String normalizedSubject = subject.trim().isEmpty
        ? (service?.subject.isNotEmpty == true
              ? service!.subject
              : tutor.expertiseDomain)
        : subject.trim();
    final int normalizedSessionsCount = sessionsCount < 1 ? 1 : sessionsCount;
    final int normalizedDuration = sessionDurationMinutes < 15
        ? 30
        : sessionDurationMinutes;

    final Map<String, dynamic> quoteData = {
      'quote_id': quoteRef.id,
      'student_id': student.uid,
      'tutor_id': tutor.uid,
      'service_id': service?.serviceId ?? '',
      'service_name': service?.name ?? '',
      'subject': normalizedSubject,
      'level': student.schoolLevel,
      'objective': normalizedDescription,
      'description': normalizedDescription,
      'teaching_mode': teachingMode.trim(),
      'sessions_count': normalizedSessionsCount,
      'frequency': '$normalizedSessionsCount sessions',
      'duration': '$normalizedDuration min',
      'budget': service != null
          ? '${service.price.toInt()} DA'
          : 'To be discussed',
      'status': 'pending',
      'request_by': actor.role,
      'created_at': now,
      'createdAt': now,
    };
    if (actor.role == 'parent') {
      quoteData['parent_id'] = actor.actorId;
    }

    await quoteRef.set(quoteData);

    await _notificationService.sendNotification(
      NotificationModel(
        title: 'New quote request',
        content:
            '${student.firstName} sent a quote request${service != null ? ' for ${service.name}' : ''}.',
        dateTime: DateTime.now(),
        isRead: false,
        notificationId: '',
        receiverId: tutor.uid,
        type: 'quote_request',
        senderId: actor.actorId,
        tutorId: tutor.uid,
        serviceId: service?.serviceId ?? '',
      ),
    );
  }

  Future<ConversationModel> createOrGetConversation({
    required TutorModel tutor,
  }) async {
    final User user = _requireSignedInUser();
    final String role = await getCurrentUserRole();
    final String viewerId = role == 'parent'
        ? user.uid
        : (await getCurrentStudent()).uid;
    final ConversationModel conversation = await _chatService
        .ensureDirectConversation(
          currentUserId: viewerId,
          otherUserId: tutor.uid,
        );

    return conversation.copyWith(
      conversationName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantDisplayName: '${tutor.firstName} ${tutor.lastName}'.trim(),
      participantAvatarUrl: tutor.picture,
      participantSubtitle: tutor.expertiseDomain,
      isVerified: (tutor as dynamic).Certified ?? false,
      isOnline: tutor.isAvailable,
    );
  }

  Future<_ActionActor> _resolveActionActor({String? childStudentId}) async {
    final User user = _requireSignedInUser();
    final String role = await getCurrentUserRole();

    if (role == 'parent') {
      final String childId = childStudentId?.trim() ?? '';
      if (childId.isEmpty) {
        throw Exception('Please select a child account first.');
      }

      final ParentModel parent = await getCurrentParent();
      if (parent.childrenUids.isNotEmpty &&
          !parent.childrenUids.contains(childId)) {
        throw Exception('Selected child is not linked to this parent.');
      }

      final StudentModel? child = await getStudentDataById(childId);
      if (child == null) {
        throw Exception('Selected child account was not found.');
      }

      return _ActionActor(actorId: user.uid, role: role, student: child);
    }

    if (role != 'student') {
      throw Exception(
        'Only student and parent accounts can perform this action.',
      );
    }

    final StudentModel student = await getCurrentStudent();
    return _ActionActor(actorId: user.uid, role: role, student: student);
  }
}

class _ActionActor {
  const _ActionActor({
    required this.actorId,
    required this.role,
    required this.student,
  });

  final String actorId;
  final String role;
  final StudentModel student;
}
