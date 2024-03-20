import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PDF extends StatelessWidget {
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

      // Print the extracted skills
      print('Skills: $skills');
    } catch (ex) {
      print(ex);
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
