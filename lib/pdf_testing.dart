import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/candidate.dart';
import 'package:interview_app/navBar.dart';
import 'package:interview_app/screens/homepage.dart';

class PDF extends StatelessWidget {

  PDF({super.key, required this.candidate});
  
  Candidate candidate;
  
  Future<String> _openFileExplorer(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        print('Selected PDF file: ${file.path}');
        return "${file.path}";
      } else {

        print('User canceled the picker');
        return "";
      }
    } catch (e) {
      print('Error picking PDF file: $e');
      return "";
    }
  }

  void printSkills(BuildContext context) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://processing.resumeparser.com/requestprocessing.html'))
        ..fields['product_code'] = 'e14cc20c71fd8d7b6d222cdf212f2c27'
        ..files.add(await http.MultipartFile.fromPath(
            'document', await _openFileExplorer(context)));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();


      List<String> skills = SkillsExtractor.extractSkills(responseBody);

      // Show a dialogue box with the extracted skills
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Your Skills extracted are: ',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 700,
                width: 700,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: skills.map((skill) => Text(skill)).toList(),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NavigationBarPage(candidate: candidate
                    ,)));
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (ex) {
      print('Error: $ex');
      // Show an error message if an exception occurs
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while processing the PDF file.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text('Resume'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: Image.asset(
              'assets/resume.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select your Resume ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Replace with your desired font
                    ),
                  ),
                  Text("It is also important to upload your resume before applying for job !"),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      printSkills(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomePage(candidate: candidate,)));
                    },
                    icon: Icon(Icons.file_upload),
                    label: Text(
                      'Upload PDF File',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillsExtractor {
  static List<String> extractSkills(String responseBody) {
    List<String> skills = [];

    try {
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
      List<dynamic> results = jsonResponse['Results'];
      Map<String, dynamic> hireAbilityResults = results[0]['HireAbilityJSONResults'][0];
      List<dynamic> personCompetency = hireAbilityResults['PersonCompetency'];

      for (var competency in personCompetency) {
        skills.add(competency['CompetencyName']);
      }
    } catch (ex) {
      print('Error extracting skills: $ex');
    }

    return skills;
  }
}
