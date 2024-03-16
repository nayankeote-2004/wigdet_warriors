import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/auth.dart';
import 'package:interview_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const AuthScreen2(),
  ));
}
