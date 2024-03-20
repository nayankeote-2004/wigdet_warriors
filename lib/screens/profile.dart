import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/candidate.dart';
import 'package:interview_app/navBar.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class CandidateProfilePage extends StatefulWidget {
  CandidateProfilePage({Key? key, this.candidate}) : super(key: key);
  final Candidate? candidate;

  @override
  _CandidateProfilePageState createState() => _CandidateProfilePageState();
}

class _CandidateProfilePageState extends State<CandidateProfilePage> {
  bool _isEditing = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  List<String> _selectedSkills = [];

  final List<String> techDomains = [
    'Django', 'Flask', 'Node.js', 'Flutter', 'Python Programming',
    'JavaScript Development', 'Java Development', 'Mobile App Development (iOS)',
    'Mobile App Development (Android)', 'React Native Development',
    'Data Analysis (Python)', 'Machine Learning', 'Cloud Computing (AWS)',
    'Cloud Computing (Azure)', 'Full Stack Web Development',
    'SQL Database Management', 'NoSQL Database Management',
    'Cybersecurity', 'DevOps Practices', 'UI/UX Design',
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
    if (widget.candidate != null) {
      _nameController.text = widget.candidate!.name;
      _emailController.text = widget.candidate!.email;
      _phoneController.text = widget.candidate!.phone;
      _selectedSkills = widget.candidate!.skills;
    }
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
      appBar: AppBar(
        title: Text('Candidate Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Roboto'), // Apply Google font
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
                    onPressed: _submitForm,
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

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'candidate.dp'),
        onCreate: (db, version) {
          return db.execute(
              'CREATE TABLE candidate_info(name TEXT PRIMARY KEY,email TEXT,phone TEXT)');
        }, version: 1);
    return db;
  }

  void addCandidate(String name, String email,String phone) async {
    // final appDir = await syspaths.getApplicationDocumentsDirectory();
    // final filename = path.basename(image.path);
    // final copiedImage = await image.copy('${appDir.path}/$filename');
    // final newPlace = Place(title: title, image: copiedImage);
    final db = await _getDatabase();
    db.insert('candidate_info', {
      'name': name,
      'email': email,
      'phone': phone,
    });
  }


  Widget buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Set border radius
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'Roboto'), // Apply Google font
      ),
    );
  }


  Widget buildMultiSelectField(String label, List<String> selectedValues) {
    return MultiSelectDialogField(
      items: techDomains.map((tech) => MultiSelectItem(tech, tech)).toList(),
      title: Text(label),
      initialValue: selectedValues,
      selectedColor: Colors.blue,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
      buttonIcon: Icon(
        Icons.add_circle_outline,
        color: Colors.blue,
      ),
      buttonText: Text(
        "Skills",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        setState(() {
          _selectedSkills = results;
        });
      },
    );
  }
  _saveStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('myStringList', _selectedSkills);
  }
  void _submitForm() async {
    final url = Uri.https(
        "widget-warriors-default-rtdb.firebaseio.com",
        'profile.json');
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'skills': _selectedSkills,
        }));
    _saveStringList();
    addCandidate(_nameController.text, _emailController.text, _phoneController.text);


    Navigator.push(context, MaterialPageRoute(builder: (ctx) => NavigationBarPage(candidate: Candidate(
      email: _emailController.text,
      skills: _selectedSkills,
      name: _nameController.text,
      phone: _phoneController.text,
    ),)));
    setState(() {
      _isEditing = false;
    });
  }
}
