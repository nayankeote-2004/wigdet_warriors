import 'package:flutter/material.dart';

class JobCard {
  final String domain;
  final String description;
  final int applicationCount;
  final List<Candidate> candidates;

  JobCard({
    required this.domain,
    required this.description,
    required this.applicationCount,
    required this.candidates,
  });
}

class Candidate {
  final String name;
  final int id;

  Candidate({
    required this.name,
    required this.id,
  });
}

class ApplicationList extends StatelessWidget {
   ApplicationList({super.key});

   final List<JobCard> jobCards = [
     JobCard(
       domain: 'App Development',
       description: 'Seeking a highly skilled mobile app developer with experience in Flutter for the development of innovative and user-friendly applications. The ideal candidate should have a strong understanding of mobile UI/UX design principles and be proficient in integrating APIs and third-party libraries. Previous experience in agile development methodologies is a plus.',
       applicationCount: 2,
       candidates: [
         Candidate(name: 'John Doe', id: 1),
         Candidate(name: 'Alice Smith', id: 2),
         // Add more candidates here...
       ],
     ),
     JobCard(
       domain: 'Web Development',
       description: 'We are looking for a frontend developer who is passionate about crafting elegant user interfaces and has a keen eye for detail. The successful candidate will work closely with our design team to implement responsive web designs and ensure cross-browser compatibility. Proficiency in HTML, CSS, JavaScript, and frameworks such as React or Angular is required.',
       applicationCount: 2,
       candidates: [
         Candidate(name: 'Bob Johnson', id: 3),
         Candidate(name: 'Emily Brown', id: 4),
         // Add more candidates here...
       ],
     ),
     JobCard(
       domain: 'Blockchain',
       description: 'We are seeking a talented blockchain developer to join our team and contribute to the development of decentralized applications (dApps). The ideal candidate should have a strong understanding of blockchain fundamentals, including smart contracts and consensus mechanisms. Experience with blockchain platforms such as Ethereum and Solidity programming language is highly desirable.',
       applicationCount: 2,
       candidates: [
         Candidate(name: 'Bob Johnson', id: 3),
         Candidate(name: 'Emily Brown', id: 4),
         // Add more candidates here...
       ],

     ),
     JobCard(
       domain: 'AI/ML',
       description: 'We are looking for a passionate machine learning engineer to join our AI team and work on cutting-edge projects in natural language processing, computer vision, and predictive analytics. The successful candidate will collaborate with cross-functional teams to design and implement machine learning algorithms and models. Proficiency in Python, TensorFlow, and experience with large-scale data processing is required.',
       applicationCount: 2,
       candidates: [
         Candidate(name: 'Bob Johnson', id: 3),
         Candidate(name: 'Emily Brown', id: 4),
         // Add more candidates here...
       ],
     ),
     // Add more dummy data here...
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: jobCards.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text( "Job Title: ${jobCards[index].domain}" ),
              subtitle: Text("Job Description: ${jobCards[index].description}"),

              trailing: ElevatedButton(
                onPressed: (){
                  _showCandidatesDialog(context, jobCards[index].candidates);
                },
                child: Text(
                '${jobCards[index].applicationCount} Applications',
                style: TextStyle(color: Colors.green),
              ), ),
            ),
          );
        },
      ),
    );
  }
}

void _showCandidatesDialog(BuildContext context, List<Candidate> candidates) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Candidates'),
        content: Container(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: candidates.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(candidates[index].name),
                subtitle: Text('ID: ${candidates[index].id}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}


