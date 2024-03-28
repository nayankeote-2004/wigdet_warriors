import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/screens/recruterScreens/applicants.dart';

import '../../candidate.dart';
import 'addJob.dart';

class JobCard {
  final String domain;
  final String description;
  final int applicationCount;
  final List<Candidate> candidates;
  final int salary;

  JobCard({
    required this.domain,
    required this.description,
    required this.applicationCount,
    required this.candidates,
    required this.salary,
  });
}

class ApplicationList extends StatefulWidget {
  ApplicationList({Key? key}) : super(key: key);

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  late List<JobCard> _jobCards;

  @override
  void initState() {
    super.initState();
    _jobCards = [];
    fetchJobData();
  }

  Future<void> fetchJobData() async {
    final jobUrl = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'job.json',
    );
    final candidateUrl = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'apply.json',
    );

    try {
      final jobResponse = await http.get(jobUrl);
      final candidateResponse = await http.get(candidateUrl);

      if (jobResponse.statusCode >= 400 || candidateResponse.statusCode >= 400) {
        throw Exception("Failed to fetch data");
      }

      final Map<String, dynamic>? jobList = json.decode(jobResponse.body);
      final Map<String, dynamic>? candidateList = json.decode(candidateResponse.body);

      if (jobList == null || candidateList == null) {
        throw Exception("Data is null");
      }

      List<JobCard> jobCards = [];

      jobList.forEach((key, value) {
        List<Candidate> candidates = [];
        candidateList.forEach((candidateKey, candidateValue) {
          if (candidateValue['title'] == value['title']) {
            Candidate candidate = Candidate(
              name: candidateValue['name'] ?? '',
              phone: candidateValue['phone'] ?? '',
              email: candidateValue['email'] ?? '',
              skills: List<String>.from(candidateValue['skills'] ?? []),
            );
            candidates.add(candidate);
          }
        });

        JobCard job = JobCard(
          domain: value['title'] ?? '',
          description: value['description'] ?? '',
          salary: value['salary'] ?? 0,
          candidates: candidates,
          applicationCount: candidates.length,
        );

        jobCards.add(job);
      });

      setState(() {
        _jobCards = jobCards;
      });
    } catch (error) {
      throw Exception("Error fetching data: $error");
    }
  }

  Future<List<Candidate>> getCandidateList(String title) async {
    List<Candidate> candidates = [];
    final url = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'apply.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      } else {
        final Map<String, dynamic> candidateData = json.decode(response.body);
        candidateData.forEach((key, value) {
          if (value['title'] == title) {
            Candidate candidate = Candidate(
              name: value['name'] ?? '',
              phone: value['phone'] ?? '',
              email: value['email'] ?? '',
              skills: List<String>.from(value['skills'] ?? []),
            );
            candidates.add(candidate);
          }
        });
      }
    } catch (error) {
      throw Exception("Error fetching candidates: $error");
    }
    return candidates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hiring"),
      ),
      body: _jobCards.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _jobCards.length,
        itemBuilder: (BuildContext context, int index) {
          final jobCard = _jobCards[index];
          return GestureDetector(
            onTap: () async {
              final candidates = await getCandidateList(jobCard.domain);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => CandidatesList(Title: jobCard.domain, candidates: candidates),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Job Title: ${jobCard.domain}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Job Description: ${jobCard.description}",
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle button press
                          },
                          child: Text(
                            '${jobCard.applicationCount} Applications',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddJobScreen()));
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
