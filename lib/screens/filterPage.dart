import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/screens/recruterScreens/email_invitation.dart';

import '../candidate.dart';

class AppliedJobs extends StatefulWidget {
  AppliedJobs({super.key, required this.candidate});
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



  List<Candidate> Invitedcandidates = [];
  List<Candidate> Rejectedcandidates = [];


  Future<void> filter() async {
    final inviteURl = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'invite.json',
    );
    final rejectURl = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'reject.json',
    );

    try {
      final jobResponse = await http.get(inviteURl);
      final candidateResponse = await http.get(rejectURl);

      if (jobResponse.statusCode >= 400 || candidateResponse.statusCode >= 400) {
        throw Exception("Failed to fetch data");
      }

      final Map<String, dynamic>? inviteList = json.decode(jobResponse.body);
      final Map<String, dynamic>? rejectList = json.decode(candidateResponse.body);

      if (inviteList == null || rejectList == null) {
        throw Exception("Data is null");
      }



        rejectList.forEach((candidateKey, candidateValue) {

            Candidate candidate = Candidate(
              name: candidateValue['name'] ?? '',
              phone: candidateValue['phone'] ?? '',
              email: candidateValue['email'] ?? '',
              skills: List<String>.from(candidateValue['skills'] ?? []),
            );
            Rejectedcandidates.add(candidate);

        });

      inviteList.forEach((candidateKey, candidateValue) {

        Candidate candidate = Candidate(
          name: candidateValue['name'] ?? '',
          phone: candidateValue['phone'] ?? '',
          email: candidateValue['email'] ?? '',
          skills: List<String>.from(candidateValue['skills'] ?? []),
        );
        Invitedcandidates.add(candidate);

      });
    } catch (error) {
      throw Exception("Error fetching data: $error");
    }
  }

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
            if (widget.candidate.name == value['name'])
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
            padding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      style: GoogleFonts.poppins(
                        fontSize: 23,
                        color: Colors.black87,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          // primary: Colors.blue, // Button color
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

  bool canApply() {
    return true;
  }

  void _showApplyDialog(BuildContext context, String companyName) {
    bool isInvited = Invitedcandidates.any((candidate) => candidate.name == widget.candidate.name);

    if (isInvited) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Apply for $companyName?',
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to apply for $companyName?',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => MailScreen(
                        emailId: widget.candidate.email,
                        name: widget.candidate.name,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Enter OTP',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Adjust the border radius as needed
            ),
            elevation: 10.0, // Add elevation for a 3D effect
            backgroundColor: Colors.white, // Set background color
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Feedback for $companyName',
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Sorry, you are not invited to verify $companyName.',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 10.0,
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }

}

