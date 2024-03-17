import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/screens/recruterScreens/email_invitation.dart';

import '../candidate.dart';

class AppliedJobs extends StatefulWidget {
  AppliedJobs({super.key,required this.candidate});
  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
  Candidate candidate;
}

class JobInfoCandidate {
  final String title;

  JobInfoCandidate({
    required this.title,
  });
}

class _AppliedJobsState extends State<AppliedJobs> {
  final List<JobInfoCandidate> companies = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  void loadScreen() async {
    final url = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'apply.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          errorMessage = "Failed to fetch data";
        });
      } else {
        final Map<String, dynamic> list = json.decode(response.body);
        print(response);
        print(list);
        list.forEach((key, value) {
          JobInfoCandidate job = JobInfoCandidate(
            title: value['title'],

          );
          setState(() {
            if(widget.candidate.name == value['name'])
            companies.add(job);
          });
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = "Error: $error";
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify jobs'),
      ),
      body: errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _showApplyDialog(context, company.title);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool canApply(){



    return true;
  }

  void _showApplyDialog(BuildContext context, String companyName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply for $companyName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: ()  {

                Navigator.push(context, MaterialPageRoute(builder: (ctx) => MailScreen(emailId: widget.candidate.email, name: widget.candidate.name)));

              },
              child: Text(
                'Enter otp',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }


}
