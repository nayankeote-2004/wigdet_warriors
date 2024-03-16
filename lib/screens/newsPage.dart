import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
  }

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=c1e6df5e095847ddbe3bc6e6d44b7ca0'));

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response Data: $responseData'); // Print response data
        if (responseData.containsKey('articles')) {
          List<dynamic> articlesJson = responseData['articles'];
          return articlesJson.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception('No articles found');
        }
      } else {
        throw Exception('Empty response body');
      }
    } else {
      throw Exception('Failed to load articles: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Implement navigation to a new screen to display complete news description
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            snapshot.data![index].imageUrl, // Assuming imageUrl is a property in your Article class
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data![index].title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                          child: Text(
                            snapshot.data![index].description,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl; // Assuming imageUrl is a property in your Article class

  Article({required this.title, required this.description, required this.imageUrl});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '', // Assuming 'urlToImage' is the key for the image URL in the API response
    );
  }
}
