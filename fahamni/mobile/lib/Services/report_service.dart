import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/report_model.dart';

class ReportService {
  ReportService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  Future<void> submitTeacherReport({
    required String teacherId,
    required String teacherName,
    required String description,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('You need to be signed in first.');
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final String role = (userDoc.data()?['role'] as String?) ?? 'student';

    final String reporterName = await _loadDisplayName(user.uid, role);
    final DocumentReference<Map<String, dynamic>> reportRef = _firestore
        .collection('reports')
        .doc();

    final String normalizedDescription = description.trim();
    if (normalizedDescription.isEmpty) {
      throw Exception('Please provide a description.');
    }

    final ReportModel report = ReportModel(
      reportId: reportRef.id,
      reporterUid: user.uid,
      reporterName: reporterName,
      reportedId: teacherId,
      reportedName: teacherName,
      type: ReportType.teacher,
      text: normalizedDescription,
      createdAt: DateTime.now(),
    );

    await reportRef.set({
      ...report.toMap(),
      'reporterId': user.uid,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'description': normalizedDescription,
      'reporterRole': role,
      'createdAt': FieldValue.serverTimestamp(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<String> _loadDisplayName(String uid, String role) async {
    final String collection = role == 'tutor'
        ? 'tutors'
        : role == 'parent'
        ? 'parents'
        : 'students';

    final DocumentSnapshot<Map<String, dynamic>> profile = await _firestore
        .collection(collection)
        .doc(uid)
        .get();

    final String firstName = (profile.data()?['first_name'] as String?) ?? '';
    final String lastName = (profile.data()?['last_name'] as String?) ?? '';
    final String fullName = '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    return _auth.currentUser?.displayName?.trim().isNotEmpty == true
        ? _auth.currentUser!.displayName!.trim()
        : 'Anonymous Reporter';
  }
}
