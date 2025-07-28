import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(Mashro3yApp());
}

class Mashro3yApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mashro3y',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
