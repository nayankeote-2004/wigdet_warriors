import 'package:flutter/material.dart';

import 'applicationslist.dart';
class RecruterHomePage extends StatelessWidget {
  const RecruterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellowAccent,
        body: ApplicationList(),
      ),

    );
  }
}
