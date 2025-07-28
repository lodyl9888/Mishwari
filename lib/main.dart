import 'package:flutter/material.dart';
import 'package:mishwari/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MishwariApp());
}

class MishwariApp extends StatelessWidget {
  const MishwariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mishwary',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
