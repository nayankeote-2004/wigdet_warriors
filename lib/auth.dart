import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:widget_wizards/NavBar.dart';

// import '../organization/email_otp.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class AuthScreen2 extends StatefulWidget {
  const AuthScreen2({Key? key}) : super(key: key);

  @override
  _AuthScreen2State createState() => _AuthScreen2State();
}

class _AuthScreen2State extends State<AuthScreen2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _userType = 'User';

  final List<String> _userTypes = ["User", "Organization"];

  void _submitForm() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    form.save();

    try {
      UserCredential userCredential;
      if (_isLogin) {
        userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        /*if (_userType == "Organization") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((ctx) => OtpScreen(emailId: _email)),
            ),
          );
        }
        else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((ctx) => NavBar()),
            ),
          );
        }*/
      } else {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Icon(Icons.check_circle, color: Colors.green, size: 50),
            content: Text('Account created successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (ctx) => OrganizationScreen(),
                  //   ),
                  // );
                  // Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NavBar()));
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      print(userCredential);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("Humanity Link"),
      ),
      backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    _isLogin ? 'assets/login.png' : 'assets/signup.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _userType,
                          decoration: const InputDecoration(
                            labelText: 'User Type',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          items: _userTypes.map((String userType) {
                            return DropdownMenuItem<String>(
                              value: userType,
                              child: Text(userType),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {
                                _userType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value ?? '';
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value ?? '';
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ButtonStyle(

                           backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.teal),
                          ),
                          onPressed: _submitForm,
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create an account'
                              : 'I already have an account',
                          style: TextStyle(
                            color: Colors.teal
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}