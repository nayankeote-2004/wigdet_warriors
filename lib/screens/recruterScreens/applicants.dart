import 'package:flutter/material.dart';

import 'applicationslist.dart';

class CandidatesList extends StatelessWidget {
  const CandidatesList({super.key, required this.candidates});

  final List<Candidate> candidates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidates '),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(candidates[index].name),
              subtitle: Text('ID: ${candidates[index].id}'),
            ),
          );
        },
      ),
    );
  }
}