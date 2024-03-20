import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../candidate.dart';
import '../homepage.dart';
import '../newsPage.dart';
import 'addJob.dart';
import 'applicants.dart';

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
  late Future<List<JobCard>> _futureJobCards;
  void initState() {
    super.initState();
    _futureJobCards = loadScreen(); // Call the function to fetch and set data
  }

  Future<void> giveData() async {
    try {
      final jobCards = await loadScreen();
      setState(() {
        _futureJobCards = Future.value(jobCards);
      });
    } catch (error) {
      // Handle error
      print("Error fetching data: $error");
    }
  }

  Future<List<JobCard>> loadScreen() async {
    final url = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'job.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data");
      } else {

        final Map<String, dynamic> list = json.decode(response.body);

        List<JobCard> jobCards = [];
        await Future.forEach(list.entries, (entry) async {
          JobCard job = JobCard(
            domain: entry.value['title'],
            description: entry.value['description'],
            salary: entry.value['salary'],
            candidates: await getCandidates(entry.value['title']),
            applicationCount: (await getCandidates(entry.value['title'])).length,
          );
          jobCards.add(job);
        });
        print("Response Body: $jobCards");
        return jobCards;
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
  }

  Future<List<Candidate>> getCandidates(String title) async {
    List<Candidate> candidates = [];
    final url = Uri.https(
      "widget-warriors-default-rtdb.firebaseio.com",
      'apply.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception("Failed to fetch data");
      } else {
        final Map<String, dynamic>? list = json.decode(response.body);
        if (list != null) {

          list.forEach((key, value) {
            if (value['title'] == title) {
              Candidate candidate = Candidate(
                name: value['name'],
                phone: value['phone'],
                email: value['email'],
                skills: List<String>.from(value['skills']),
              );
              candidates.add(candidate);
            }
          });
        } else {
          print("Response Body is null");
        }
      }
    } catch (error) {
      throw Exception("Error: $error");
    }
    print("Response Body: $candidates");
    if(candidates == null)
      return [];
    return candidates;
  }




  @override
  Widget build(BuildContext context) {
    return (_futureJobCards == null) ? CircularProgressIndicator()
        :
    Scaffold(
      appBar: AppBar(
        title: Text("Hiring"),
      ),
      body: FutureBuilder<List<JobCard>>(
        future: _futureJobCards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final jobCard = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => CandidatesList(candidates: jobCard.candidates,Title: jobCard.domain,),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => CandidatesList(candidates: jobCard.candidates,Title: jobCard.domain,),
                                    ),
                                  );
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
            );
          }
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
