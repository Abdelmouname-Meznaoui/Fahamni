import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';

class SessionService {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'sessions';

  // CREATE
  Future<void> createSession(SessionModel session) async {
    await _db.collection(_collection).doc(session.sessionId).set(session.toMap());
  }

  // READ
  Stream<List<SessionModel>> streamSessions(String studentId, DateTime startOfWeek) {


    return _db.collection(_collection)
        .where('student_ids', arrayContains: studentId)

        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      return SessionModel.fromMap(doc.data());
    }).toList());
  }

  // UPDATE
  Future<void> updateSession(SessionModel session) async {
    await _db.collection(_collection).doc(session.sessionId).update(session.toMap());
  }
  //DELETE
  Future<void> deleteSession(String sessionId) async {
    await _db.collection(_collection).doc(sessionId).delete();
  }
}