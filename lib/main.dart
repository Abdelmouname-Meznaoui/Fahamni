/*import 'package:fahamni/StudentHomePage/Student_homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'Splash_Screen/splash.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Studentpage(),
    );
  }
}*/
import 'package:flutter/material.dart';
//import 'package:fahamni/screens/personal_info_screen.dart';
import 'package:fahamni/screens/account_screen.dart';
//import 'package:fahamni/screens/study_info_screen.dart';
//import 'package:fahamni/screens/profile_settings.dart';
//import 'package:fahamni/screens/notification_screen.dart';
//import 'package:fahamni/screens/language_screen.dart';
//import 'package:fahamni/screens/help_support_screen.dart';
//import 'package:fahamni/screens/delete_account_screen.dart';
//import 'package:fahamni/screens/change_password_screeen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountScreen(),
    );
  }
}