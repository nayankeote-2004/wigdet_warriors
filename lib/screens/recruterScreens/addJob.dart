import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview_app/screens/recruterScreens/recruternavbar.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class AddJobScreen extends StatefulWidget {
  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _vacancyController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  List<String> _selectedSkills = [];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Job'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Job Title'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _vacancyController,
                decoration: InputDecoration(labelText: 'Maximum Vacancy'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              buildMultiSelectField("Skills",_selectedSkills),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.https(
                    "widget-warriors-default-rtdb.firebaseio.com",
                    'job.json',
                  );
                  final response = await http.post(
                    url,
                    headers: {'Content-type': 'application/json'},
                    body: json.encode({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'vacancy': int.parse(_vacancyController.text),
                      'salary': int.parse(_salaryController.text),
                      'skills': _selectedSkills,
                    }),
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>RecruterNavBar()));
                },
                child: Text('Add Job'),
              ),
            ],
          ),
        ),
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
}
