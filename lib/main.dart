import 'package:fahamni/StudentHomePage/Student_homepage.dart';
import 'package:fahamni/messaging/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Splash_Screen/splash.dart';
import 'messaging/chat_page.dart';
import 'chattest.dart';
import 'messaging/chat_buttons.dart';
import 'messaging/conversation_doc_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatPage(),
    );
  }
}
