import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
//import 'package:flutter/material.dart';
///import 'package:google_sign_in/google_sign_in.dart';
///import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/tutor_model.dart';
import '../models/student_model.dart';
import '../models/parent_model.dart'; 


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance; 

  Future<UserModel?> signUp(String email,String password,UserModel usermodel) async {
    try{
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = credential.user!.uid;
      final Map<String, dynamic> data = usermodel.toMap();
      data['uid'] = uid;
      final collection = _collectionForRole(usermodel.role);
      await _db.collection(collection).doc(uid).set(data);
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'role': usermodel.role.name,
      });
      return usermodel;
    }
   on FirebaseAuthException catch(e){
      throw _handleAuthError(e);
    }
    catch (e) {
    throw 'Registration failed: ${e.toString()}';
  }
  }



Future<UserModel?> login(String email, String password) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;
    final userDoc = await _db.collection('users').doc(uid).get();
    if (!userDoc.exists) {
      throw Exception('User profile not found');
    }
    final role = UserRole.values.byName(userDoc['role']);

    
    return await _fetchUserProfile(uid, role);
  } on FirebaseAuthException catch (e) {
    throw _handleAuthError(e);
  }
}

Future<UserModel?> _fetchUserProfile(String uid,UserRole role) async {
  final collection = _collectionForRole(role);
  final doc = await _db.collection(collection).doc(uid).get();
  if (!doc.exists) {
    return null;
  }
  final data = doc.data()!;
  switch (role) {
    case UserRole.student:
      return StudentModel.fromMap(data);
    case UserRole.tutor:
      return TutorModel.fromMap(data);
    case UserRole.parent:
      return ParentModel.fromMap(data);
  }
}

String _collectionForRole(UserRole role) {
  switch (role) {
    case UserRole.student:
      return 'students';
    case UserRole.tutor:
      return 'tutors';
    case UserRole.parent:
      return 'parents';
  }
}

String _handleAuthError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
        return 'This email is already registered.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
    default:
      return e.message ?? 'An unexpected error occurred. Please try again later.';
  }
}
Future<void> sendOtp({
  required String phoneNumber,      
  required void Function(String verificationId) onCodeSent,
  required void Function(String error)  onError,
}) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: const Duration(seconds: 60),
    verificationCompleted: (PhoneAuthCredential credential) async {
    },
    verificationFailed: (FirebaseAuthException e) {
      onError(_handleAuthError(e));
    },
    codeSent: (String verificationId, int? resendToken) {
      onCodeSent(verificationId);       
    },
    codeAutoRetrievalTimeout: (_) {},
  );
}

Future<UserModel> verifyOtpAndRegister({
  required String verificationId,
  required String smsCode,
  required String email,
  required String password,
  required UserModel userModel,
}) async {

  final phoneCredential = PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: smsCode,
  );

  final credential = await _auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  final uid = credential.user!.uid;

  try {
    await credential.user!.linkWithCredential(phoneCredential);
  } on FirebaseAuthException catch (e) {
    await credential.user!.delete();
    throw _handleAuthError(e);
  }
  final data = userModel.toMap();
  data['uid'] = uid;
  final collection = _collectionForRole(userModel.role);
  await _db.collection(collection).doc(uid).set(data);
  await _db.collection('users').doc(uid).set({
    'uid': uid,
    'email': email,
    'role': userModel.role.name,
  });

  return _buildModelWithUid(userModel, uid);
}

UserModel _buildModelWithUid(UserModel model, String uid) {
  if (model is StudentModel) {
    return StudentModel(
      uid: uid,
      firstName: model.firstName, lastName: model.lastName,
      email: model.email,         phone: model.phone,
      location: model.location,   gender: model.gender,
      birthday: model.birthday,   accountStatus: model.accountStatus,
      schoolLevel: model.schoolLevel,
      learningObjectives: model.learningObjectives,
      preferredSubjects: model.preferredSubjects,
    );
  } else if (model is TutorModel) {
    return TutorModel(
      uid: uid,
      firstName: model.firstName, lastName: model.lastName,
      email: model.email,         phone: model.phone,
      location: model.location,   gender: model.gender,
      birthday: model.birthday,   accountStatus: model.accountStatus,
      expertiseDomain: model.expertiseDomain,
      levelsTaught: model.levelsTaught,
      teachingMode: model.teachingMode,
      isAvailable: model.isAvailable,
      Certified: model.Certified,
      pedagogicalDescription: model.pedagogicalDescription,
      averageRating: model.averageRating,
      yearsOfExperience: model.yearsOfExperience,
      academicDescription: model.academicDescription,
    );
  } else {
    final p = model as ParentModel;
    return ParentModel(
      uid: uid,
      firstName: p.firstName, lastName: p.lastName,
      email: p.email,         phone: p.phone,
      location: p.location,   gender: p.gender,
      birthday: p.birthday,   accountStatus: p.accountStatus,
      childrenUids: p.childrenUids,
    );
  }
}

}



