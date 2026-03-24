import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'teacher_profile/teacher_profile_page.dart';
import 'models/tutor_model.dart';
import 'package:fahamni/models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tutor = TutorModel(
      uid: '123',
      firstName: 'Sami',
      lastName: "Djellal",
      levelsTaught: [],
      location: "Mila, Mila",
      isAvailable: false,
      email: "",
      expertiseDomain: "Mathematics & Physics",
      academicDescription: "PhD in Applied Mathematics from University of Algiers. Published researcher in computational fluid dynamics with a focus on educational modeling.",
      averageRating: 4.8,
      gender: Gender.male,
      pedagogicalDescription: "I focus on conceptual understanding rather than rote memorization. My lessons are interactive, using real-world examples to make complex topics relatable and easier to grasp.",
      phone: "",
      picture: "assets/images/indian-male-teacher_981168-3023.avif",
      teachingMode: "Hybrid",
      birthday: DateTime.now(),
      yearsOfExperience: 8,
      accountStatus: AccountStatus.pending,
      Certified: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeacherProfilePage(tutor: tutor),
    );
  }
}