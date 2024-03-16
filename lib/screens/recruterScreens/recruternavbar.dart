import 'package:flutter/material.dart';
import 'package:interview_app/screens/filterPage.dart';
import 'package:interview_app/screens/homepage.dart';
import 'package:interview_app/screens/profile.dart';
import 'package:interview_app/screens/recruterScreens/recruterHomePage.dart';

import 'companyprofile.dart';

class RecruterNavBar extends StatefulWidget {
  @override
  _RecruterNavBarState createState() => _RecruterNavBarState();
}

class _RecruterNavBarState extends State<RecruterNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    RecruterHomePage(),
    ProfilePage(),
  ];

  final List<String> _appBarTitles = <String>[
    'Hirings',
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
            label: 'Hirings',
          ),

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.filter),
          //   label: 'Filters',
          // ),
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
