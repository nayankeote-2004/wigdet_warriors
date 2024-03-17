import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/auth.dart';
import 'package:interview_app/firebase_options.dart';
import 'package:interview_app/navBar.dart';
import 'package:interview_app/screens/filterPage.dart';
import 'package:interview_app/screens/profile.dart';
import 'package:interview_app/screens/recruterScreens/recruterHomePage.dart';
import 'package:interview_app/screens/recruterScreens/recruternavbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:  AuthScreen2(),
  ));
}

