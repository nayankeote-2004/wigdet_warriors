import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_app/screens/recruterScreens/email_invitation.dart';
import 'package:interview_app/screens/recruterScreens/feedback.dart';
import '../../candidate.dart';
import 'package:http/http.dart' as http;

class CandidatesList extends StatefulWidget {
  final List<Candidate> candidates;
  String Title;

  CandidatesList({required this.candidates, required this.Title});

  @override
  State<CandidatesList> createState() => _CandidatesListState();
}

class _CandidatesListState extends State<CandidatesList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    atsScore(widget.Title);
  }

  String PromptGiver(Candidate candidate, String Title) {
    String Prompt =
        '''The list of skills required for the job position are: [Frontend Development: HTML, CSS, JavaScript Development, React.js Development, UI/UX Design (optional)
  Backend Development: Django, Flask, Node.js, Python Programming, Java Development (optional), PHP Development (optional), Full Stack Web Development, SQL Database Management, NoSQL Database Management, API Development, GraphQL
  DevOps Practices: Git Version Control, Docker, Kubernetes (optional)].
  The candidate's resume skills are: ${candidate.skills}.
  The job Title : ${Title}.
  Please calculate the percentage match between the required skills according to job Title and the candidate's skills. Provide me only single number answer as the final score as a two-digit integer (rounded down). 
  important: wrap that 2 digit number in double quotes like "42"''';
    print(Prompt);
    return Prompt;
  }

  final url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBi8FqU87zs0Afkdt_oL_GyIDVEywJdW1o';

  // https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY
  final header = {
    'Content-Type': 'application/json',
  };

  String JFS = '10';

  Map<String, String> atsCandidate = {};
  int generate() {
    Random r = Random();
    return r.nextInt(24) +
        1; // Generates a random number between 0 and 9, so we add 1 to make it between 1 and 10.
  }

  void atsScore(String Title) async {
    for (Candidate candidate in widget.candidates) {
      var data = {
        "contents": [
          {
            "parts": [
              {"text": PromptGiver(candidate, Title)}
            ]
          }
        ]
      };
      await http
          .post(Uri.parse(url), headers: header, body: jsonEncode(data))
          .then((value) {
        if (value.statusCode == 200) {
          var result = jsonDecode(value.body);
          print(result['candidates'][0]['content']['parts'][0]['text']);
          String score =
              result['candidates'][0]['content']['parts'][0]['text'] as String;
          print("ATS SCORE $score");
          String extractedString = score.split(
              '"')[1]; // Splitting the string by " and getting the second part
          print("Extacted String $extractedString");
          num n = num.parse(extractedString);
          if (n < 20) {
            JFS = generate().toString();
          } else {
            JFS = extractedString;
          }
        } else {
          print("error occured");
        }
      }).catchError((e) {});
      setState(() {
        atsCandidate[candidate.name] = JFS;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts
            .latoTextTheme(), // Use Google Fonts package to set a good font
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Candidates'),
        ),
        body: ListView.builder(
          itemCount: widget.candidates.length,
          itemBuilder: (BuildContext context, int index) {
            final candidate = widget.candidates[index];
            final jfs = atsCandidate[candidate.name] ??
                '-1'; // Get JFS value from the map, or use '-1' if not found
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(candidate.name),
                subtitle: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${candidate.email}'),
                        Text('Phone: ${candidate.phone}'),
                        Text('Skills: ${candidate.skills.join(', ')}'),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final url = Uri.https(
                                      "widget-warriors-default-rtdb.firebaseio.com",
                                      'invite.json');
                                  final response = await http.post(url,
                                      headers: {
                                        'Content-type': 'application/json',
                                      },
                                      body: json.encode({
                                        'name': candidate.name,
                                        'email': candidate.email,
                                        'phone': candidate.phone,
                                        'skills': candidate.skills,
                                        'title': widget.Title
                                      }));
                                  print(response);
                                  _showInviteDialog(context, candidate);
                                },
                                child: Text("Invite")),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  final url = Uri.https(
                                      "widget-warriors-default-rtdb.firebaseio.com",
                                      'reject.json');
                                  final response = await http.post(url,
                                      headers: {
                                        'Content-type': 'application/json',
                                      },
                                      body: json.encode({
                                        'name': candidate.name,
                                        'email': candidate.email,
                                        'phone': candidate.phone,
                                        'skills': candidate.skills,
                                        'title': widget.Title,
                                      }));
                                  print(response);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => StarRating()));
                                },
                                child: Text("Reject"))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    // Your onTap logic here
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 05,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize
                            .min, // Ensure the container's height is adjusted to its content
                        children: [
                          Text(
                            jfs,
                            style: TextStyle(
                              fontSize: 10, // Adjust the font size as needed
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  4), // Add some space between JFS and the circle
                          Text(
                            'JFS Score',
                            style: TextStyle(
                              fontSize: 14, // Adjust the font size as needed
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  8), // Add more space for better aesthetics
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, Candidate candidate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invite Candidate'),
          content: Text('Do you want to invite ${candidate.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Navigate to the email invitation screen

              },
              child: Text('Invite'),
            ),
          ],
        );
      },
    );
  }
}
