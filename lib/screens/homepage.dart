import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../candidate.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key,required this.candidate});
  @override
  State<HomePage> createState() => _HomePageState();
  Candidate candidate;
}

class JobInfo {
  final String title;
  final String description;
  final int vacancy;
  final int salary;
  final List<String> skills;

  JobInfo({
    required this.title,
    required this.description,
    required this.vacancy,
    required this.salary,
    required this.skills,
  });
}

class _HomePageState extends State<HomePage> {
  final List<JobInfo> companies = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  void loadScreen() async {
    final url = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'job.json',
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
          JobInfo job = JobInfo(
            title: value['title'],
            description: value['description'],
            salary: value['salary'],
            skills: List<String>.from(value['skills']),
            vacancy: value['vacancy'],
          );
          setState(() {
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
        title: Text('Jobs'),
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
                    SizedBox(height: 8),
                    Text(
                      'Description: ${company.description}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Salary: \$${company.salary}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vacancy: ${company.vacancy}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: company.skills.map((skill) {
                        return Chip(
                          label: Text(skill),
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),
                        );
                      }).toList(),
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
                          'Apply',
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
              onPressed: () async {

                final url = Uri.https(
                  "widget-warriors-default-rtdb.firebaseio.com",
                  'apply.json',
                );
                final response = await http.post(
                  url,
                  headers: {'Content-type': 'application/json'},
                  body: json.encode({
                    'title': companyName,
                    'name': widget.candidate.name,
                    'email': widget.candidate.email,
                    'phone': widget.candidate.phone,
                    'skills': widget.candidate.skills,
                  }),
                );

                Navigator.of(context).pop();
                _showSuccessDialog(context);
              },
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Successfully Applied!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
