import 'package:flutter/material.dart';

class SelectSkillsPage extends StatefulWidget {
  @override
  _SelectSkillsPageState createState() => _SelectSkillsPageState();
}

class _SelectSkillsPageState extends State<SelectSkillsPage> {
  // List of available options
  final List<String> techDomains = [
    'Django',
    'Flask',
    'Node.js',
    'Flutter',
    'Python Programming',
    'JavaScript Development',
    'Java Development',
    'Mobile App Development (iOS)',
    'Mobile App Development (Android)',
    'React Native Development',
    'Data Analysis (Python)',
    'Machine Learning',
    'Cloud Computing (AWS)',
    'Cloud Computing (Azure)',
    'Full Stack Web Development',
    'SQL Database Management',
    'NoSQL Database Management',
    'Cybersecurity Awareness',
    'DevOps Practices',
    'UI/UX Design',
    'React.js Development',
    'Big Data Technologies',
    'PHP Development',
    'C# Development',
    'Kotlin Development',
    'Swift Development',
    'Docker',
    'Kubernetes',
    'Git Version Control',
    'Frontend Development',
    'Backend Development',
    'API Development',
    'GraphQL',
    'Rust Programming',
    'TypeScript',
    'Angular Development',
    'Vue.js Development',
    'Firebase Development',
    'TensorFlow',
    'Natural Language Processing (NLP)',
    'Blockchain Development',
    'Ethereum Smart Contracts',
    'CI/CD Pipeline Management',
    'Microservices Architecture',
    'Test-Driven Development (TDD)',
    'Agile Methodologies',
    'Web Accessibility (A11y)',
    'Responsive Web Design',
    'Progressive Web Apps (PWAs)',
    'Serverless Computing',
    'Data Engineering',
    'Robotics Programming',
  ];

  // Set to store selected skills
  Set<String> selectedSkills = {};

  // Filtered options based on search query
  List<String> filteredOptions = [];

  @override
  void initState() {
    filteredOptions = techDomains;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filteredOptions = techDomains
                      .where((option) =>
                          option.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search for skills...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final techDomain = filteredOptions[index];
                return CheckboxListTile(
                  title: Text(techDomain),
                  value: selectedSkills.contains(techDomain),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedSkills.add(techDomain);
                      } else {
                        selectedSkills.remove(techDomain);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Proceed further with selected skills
          print('Selected skills: $selectedSkills');
          // Add your navigation logic here
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Select Skills',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectSkillsPage(),
    );
  }
}
