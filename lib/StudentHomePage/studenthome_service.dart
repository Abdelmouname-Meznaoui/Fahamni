import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fahamni/models/session_model.dart';
import 'package:fahamni/models/tutor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';

class studenthomepage_service {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current student data
  Future<StudentModel> getStudentData() async {
    final uid ="9zkATIGDeeNmWBKHvmv8VikNlJj1";  //_auth.currentUser!.uid;

    final doc = await _db.collection('students').doc(uid).get();
    try {
      return StudentModel.fromMap(doc.data()!);
    } catch (e) {
      print('ERROR: $e');
      rethrow;
    }
  }
  Future<TutorModel> getTutorData(String id) async {

    final doc = await _db.collection('tutors').doc(id).get();
    try {
      return TutorModel.fromMap(doc.data()!);
    } catch (e) {
      print('ERROR: $e');
      rethrow;
    }
  }
  Future<List<TutorModel>> getFavoriteTeachers(List<String> ids) async {
    final docs = await Future.wait(
        ids.map((id) => _db.collection('tutors').doc(id).get())
    );
    return docs.map((doc) => TutorModel.fromMap(doc.data()!)).toList();
  }
  Future<List<SessionModel>> getCourses(List<String> ids) async {
    final docs = await Future.wait(
        ids.map((id) => _db.collection('sessions').doc(id).get())
    );
    return docs.map((doc) => SessionModel.fromMap(doc.data()!)).toList();
  }
}