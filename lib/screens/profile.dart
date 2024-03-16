import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:http/http.dart' as http;

class CandidateProfilePage extends StatefulWidget {
  @override
  _CandidateProfilePageState createState() => _CandidateProfilePageState();
}

class _CandidateProfilePageState extends State<CandidateProfilePage> {
  bool _isEditing = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  List<String> _selectedSkills = []; // List to store selected skills

  final List<String> techDomains = [
    'Django', 'Flask', 'Node.js', 'Flutter', 'Python Programming',
    'JavaScript Development', 'Java Development', 'Mobile App Development (iOS)',
    'Mobile App Development (Android)', 'React Native Development',
    'Data Analysis (Python)', 'Machine Learning', 'Cloud Computing (AWS)',
    'Cloud Computing (Azure)', 'Full Stack Web Development',
    'SQL Database Management', 'NoSQL Database Management',
    'Cybersecurity Awareness', 'DevOps Practices', 'UI/UX Design',
    'React.js Development', 'Big Data Technologies', 'PHP Development',
    'C# Development', 'Kotlin Development', 'Swift Development',
    'Docker', 'Kubernetes', 'Git Version Control', 'Frontend Development',
    'Backend Development', 'API Development', 'GraphQL', 'Rust Programming',
    'TypeScript', 'Angular Development', 'Vue.js Development',
    'Firebase Development', 'TensorFlow', 'Natural Language Processing (NLP)',
    'Blockchain Development', 'Ethereum Smart Contracts',
    'CI/CD Pipeline Management', 'Microservices Architecture',
    'Test-Driven Development (TDD)', 'Agile Methodologies',
    'Web Accessibility (A11y)', 'Responsive Web Design',
    'Progressive Web Apps (PWAs)', 'Serverless Computing', 'Data Engineering',
    'Robotics Programming',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with dummy data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1234567890';
    _selectedSkills = ['Java', 'Python', 'Flutter']; // Initial selected skills
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              buildTextField('Name', _nameController),
              SizedBox(height: 16),
              buildTextField('Email', _emailController),
              SizedBox(height: 16),
              buildTextField('Phone', _phoneController),
              SizedBox(height: 16),
              buildMultiSelectField('Skills', _selectedSkills),
              SizedBox(height: 32),
              _isEditing
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Save changes
                      // Implement your save logic here
                      final url = Uri.https("widget-warriors-default-rtdb.firebaseio.com", 'profile.json');
                      final response = await http.post(url,
                        headers: {
                          'Content-type': 'application/json',
                        },
                        body: json.encode({
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'phone': _phoneController.text,
                          'skills': _selectedSkills, // Include selected skills
                        }));
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: Text('Save'),
                  ),
                ],
              )
                  : ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black), // Set text color to black
      ),
    );
  }

  Widget buildMultiSelectField(String label, List<String> selectedValues) {
    return MultiSelectFormField(
      initialValue: selectedValues,
      enabled: _isEditing,
      titleText: label,
      dataSource: techDomains.map((tech) {
        return {
          "display": tech,
          "value": tech,
        };
      }).toList(),
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'Cancel',
      hintText: 'Select $label',
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black), // Set text color to black
      onSaved: (value) {
        setState(() {
          _selectedSkills = value;
        });
      },
    );
  }
}
