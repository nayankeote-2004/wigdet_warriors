import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:interview_app/screens/recruterScreens/companyprofile.dart';
// import 'package:widget_wizards/organization/organization_homepage.dart';

class MailScreen extends StatefulWidget {
   MailScreen({super.key, required this.emailId,required this.name});


  String  name ;

  @override
  State<MailScreen> createState() => _MailScreenState();
  final String emailId;
}

class _MailScreenState extends State<MailScreen> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  EmailOTP myauth = EmailOTP();




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Add some spacing between text and button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: otp,
                        decoration: const InputDecoration(
                          hintText: "Enter OTP",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                          Navigator.pop(context);

                          Navigator.pop(context);
                          _showSuccessDialog(context);

                      },
                      child: const Text("Verify"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              Text('Congratulations!'),

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
