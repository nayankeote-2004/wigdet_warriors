import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Udemy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Udemy Courses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UdemyCoursesScreen(),
    );
  }
}

class UdemyCoursesScreen extends StatefulWidget {
  @override
  _UdemyCoursesScreenState createState() => _UdemyCoursesScreenState();
}

class _UdemyCoursesScreenState extends State<UdemyCoursesScreen> {
  late Future<List<dynamic>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchUdemyCourses();
  }

  Future<List<dynamic>> fetchUdemyCourses() async {
    try {
      final String clientId = 'wJCdJ3tAHNpwzgkEDVuXpokhalP5OsTtaCDjh7oX'; // Replace with your actual client ID
      final String clientSecret = 'b6a5zNa4TJKZgBoZ8NkdUbhou0smR91U59XmbDYFFEO7W97JuB1Gh7VxwGrsCOn4FCanY52WA75oZp9WcJeZ6lz9XxoUgP6j63lafngGWGHx6Qf50bPFBPUIxOYuBdis'; // Replace with your actual client secret

      // Encode the credentials in base64
      String auth = base64.encode(utf8.encode('$clientId:$clientSecret'));

      // Make an HTTP request to the Udemy API
      final response = await http.get(
        Uri.parse('https://www.udemy.com/api-2.0/courses/'),
        headers: {'Authorization': 'Basic $auth'},
      );

      if (response.statusCode == 200) {
        // Parse the response JSON
        final List<dynamic> courses = json.decode(response.body);
        return courses;
      } else {
        throw Exception('Error fetching courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Udemy Courses'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final course = snapshot.data![index];
                return ListTile(
                  title: Text(course['title']),
                  subtitle: Text(course['headline']),
                  // You can add more details here if needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
