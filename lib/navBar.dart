import 'package:firebase_messaging/firebase_messaging.dart';
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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int _selectedIndex = 0;
  @override

  void setNotification ()async
  {
    final fcm=FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    print("token {$token}");
    fcm.subscribeToTopic("notify");
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    setNotification();

  }
  // @override
  // void initState() {
  //   super.initState();
  //   _firebaseMessaging.requestPermission();
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     // Handle FCM message when the app is in the foreground
  //     print('Received message: ${message.notification?.title}');
  //   });
  // }
  //
  // String? _fcmToken;



  // void getFCMToken() {
  //   _firebaseMessaging.getToken().then((token) {
  //     setState(() {
  //       _fcmToken = token;
  //     });
  //     print("FCM Token: $_fcmToken");
  //   }).catchError((err) {
  //     print("Failed to get FCM token: $err");
  //   });
  // }


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
        // child: ElevatedButton(
        //   child: Text("hey"),
        //   onPressed: (){},
        // ),
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