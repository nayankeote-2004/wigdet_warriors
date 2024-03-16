import 'package:flutter/material.dart';
import 'package:interview_app/screens/filterPage.dart';
import 'package:interview_app/screens/homepage.dart';
import 'package:interview_app/screens/profile.dart';

class NavigationBarPage extends StatefulWidget {
  @override
  _NavigationBarPageState createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Text('News'),
    SelectSkillsPage(),
    CandidateProfilePage(),
  ];

  final List<String> _appBarTitles = <String>[
    'Openings',
    'News',
    'Skills',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
      ),
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
            icon: Icon(Icons.new_releases),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter),
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
