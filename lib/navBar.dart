import 'package:flutter/material.dart';
import 'package:interview_app/screens/filterPage.dart';
import 'package:interview_app/screens/homepage.dart';
import 'package:interview_app/screens/newsPage.dart';
import 'package:interview_app/screens/profile.dart';

import 'candidate.dart';



class NavigationBarPage extends StatefulWidget {
  NavigationBarPage({super.key, required this.candidate});
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
  Candidate candidate;
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;



  final List<String> _appBarTitles = <String>[
    'Openings',
    'Business News',
    'Skills',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePage(candidate: widget.candidate,),
      NewsPage(),
      AppliedJobs(candidate: widget.candidate,),
      CandidateProfilePage(candidate: widget.candidate,),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_appBarTitles[_selectedIndex]),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Set selected item color
        unselectedItemColor: Colors.grey, // Set unselected item color
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Openings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: ' News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt_outlined),
            label: 'Filters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}