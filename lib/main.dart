import 'package:fahamni/Student_info.dart';
import 'package:flutter/material.dart';
//import 'iPersonal_info.dart';
//import 'LoginScreen.dart';
//import 'RegistraionCompleteScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: studentinfo(), // This calls your widget from the other file
  )
  );
}