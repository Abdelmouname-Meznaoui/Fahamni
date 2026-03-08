import 'package:flutter/material.dart';
import 'Login_Screen/LoginScreen.dart';
import 'Pass_recov_page/passRec.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreenPage(), // This calls your widget from the other file
    //home: const passRec(),
  )
  );
}