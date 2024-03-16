import 'package:flutter/material.dart';
import 'package:interview_app/screens/filterPage.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> companies = [
    {'name': 'ABC Company', 'salary': '\$50,000 - \$70,000'},
    {'name': 'XYZ Corporation', 'salary': '\$60,000 - \$80,000'},
    {'name': 'Tech Solutions Ltd.', 'salary': '\$55,000 - \$75,000'},
    {'name': 'Innovative Enterprises', 'salary': '\$65,000 - \$85,000'},
    {'name': 'Future Tech Inc.', 'salary': '\$70,000 - \$90,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: companies.length,
        separatorBuilder: (context, index) => Divider(height: 0),
        itemBuilder: (context, index) {
          final company = companies[index];
          return GestureDetector(
            onTap: () {
              _showApplyDialog(context, company['name']);
            },
            child: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company['name'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Salary: ${company['salary']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _showApplyDialog(context, company['name']);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showApplyDialog(BuildContext context, String companyName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply for $companyName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessDialog(context);
              },
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
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
              Text('Successfully Applied!'),
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
