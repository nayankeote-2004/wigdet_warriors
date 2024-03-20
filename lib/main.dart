import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/auth.dart';
import 'package:interview_app/candidate.dart';
import 'package:interview_app/firebase_options.dart';
import 'package:interview_app/navBar.dart';
import 'package:interview_app/pdf_testing.dart';
import 'package:interview_app/screens/aiml/gemini.dart';
import 'package:interview_app/screens/filterPage.dart';
import 'package:interview_app/screens/homepage.dart';
import 'package:interview_app/screens/profile.dart';
import 'package:interview_app/screens/recruterScreens/addJob.dart';
import 'package:interview_app/screens/recruterScreens/applicants.dart';
import 'package:interview_app/screens/recruterScreens/applicationslist.dart';
import 'package:interview_app/screens/recruterScreens/companyprofile.dart';
import 'package:interview_app/screens/recruterScreens/recruterHomePage.dart';
import 'package:interview_app/screens/recruterScreens/recruternavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;


Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'candidate.dp'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE candidate_info(name TEXT PRIMARY KEY,email TEXT,phone TEXT)');
      }, version: 1);
  return db;
}

Future<List<String>> _retrieveStringList() async {
  List<String> skills = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  skills = prefs.getStringList('myStringList') ?? [];
  return skills;
}

Future<Candidate> loadInfo() async {
  final db = await _getDatabase();
  final data = await db.query('candidate_info');
  final candidate  =data.map(

        (row) async => Candidate(
     name:row['name'] as String,
          email: row['email'] as String,
          phone: row['phone'] as String,
          skills: await _retrieveStringList() ?? [],
    ),
  ).toList();
  if (candidate.isNotEmpty) {
    return candidate.last;
  } else {
    return Candidate(name: "", email: "", phone: "", skills: []);
  }
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
     home: Gemini(),
    // home: !(loggedIn || FirebaseAuth.instance.currentUser != null)
    //     ? const AuthScreen2()
    //     : NavigationBarPage(candidate: await loadInfo()),
  ));
}


