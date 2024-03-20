import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_app/screens/recruterScreens/feedback.dart';
import '../../candidate.dart';

class CandidatesList extends StatelessWidget {
  final List<Candidate> candidates;
  String Title;

  CandidatesList({required this.candidates, required this.Title});

  @override
  Widget build(BuildContext context) {
    '''var template = <html>
      <head>
        <title>Email OTP Template</title>
        <style>
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
          }
          .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #E0F2F1; /* Teal accent color */
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
          }
          .header {
            background-color: #009688; /* Dark teal */
            color: #fff;
            text-align: center;
            padding: 20px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
          }
          h1 {
            font-size: 24px;
            margin-bottom: 10px;
          }
          .content {
            padding: 20px;
          }
          p {
            font-size: 16px;
            color: #333;
            line-height: 1.5;
          }
          .otp {
            font-size: 36px;
            color: #FF5722;
            margin-bottom: 20px;
            font-weight: bold;
          }
          .footer {
            background-color: #f4f4f4;
            padding: 20px;
            text-align: center;
            border-bottom-left-radius: 10px;
            border-bottom-right-radius: 10px;
          }
          .footer p {
            font-size: 12px;
            color: #666;
            margin: 0;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>{{app_name}}</h1>
          </div>
          <div class="content">
            <p>Dear candidate,</p>
            <p>Thank you for choosing {{app_name}}.You are invited for ${Title}. Your One-Time Password (OTP) is: </p>
            <p class="otp">{{otp}}</p>
            <p>Please use this OTP to complete your authentication process.</p>
          </div>
          <div class="footer">
            <p>This email was sent by {{app_name}}. Please do not reply to this email.</p>
          </div>
        </div>
      </body>
    </html>''';

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Candidates'),
        ),
        body: ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (BuildContext context, int index) {
            final candidate = candidates[index];
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(candidate.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${candidate.email}'),
                    Text('Phone: ${candidate.phone}'),
                    Text('Skills: ${candidate.skills.join(', ')}'),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    // Add your interview call logic here
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Mail for Interview'),
                          content: Text(
                              'You are sending mail to ${candidate.name} for an interview.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // Implement your call for interview action here
                                // For example: Call a function to send an interview invitation
                                Navigator.of(context).pop();
                                // Show a confirmation message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Interview invitation sent to ${candidate.name}')),
                                );
                              },
                              child: Text('Mail'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, MaterialPageRoute(builder:(ctx)=>FeedbackPage(),),);
                              },
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(Icons.mail, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
