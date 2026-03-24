import 'package:fahamni/StudentHomePage/Student_homepage.dart';
import 'package:fahamni/explorepage.dart';
import 'package:fahamni/models/user_model.dart';
import 'package:fahamni/widgets/servicecard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Splash_Screen/splash.dart';
import 'models/service_model.dart';
import 'models/tutor_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final testtutor = TutorModel(
      uid: '123',
      firstName: 'Sami',
      lastName: "",
      levelsTaught: [],
      location: "",
      isAvailable: false,
      email: "",
      expertiseDomain: "",
      academicDescription: "",
      averageRating: 4.8,
      gender: Gender.male,
      pedagogicalDescription: "",
      phone: "",
      picture: "assets/images/profile.jpg",
      teachingMode: "",
      birthday: DateTime.now(),
      yearsOfExperience: 0,
      accountStatus: AccountStatus.pending,
      Certified: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Studenthomepage(),


      /* Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
              height: 450,
              width:400,
              child: ServiceCard(tutor: testtutor, service: testservice)),
        ),
      ), */
    );
  }
}
