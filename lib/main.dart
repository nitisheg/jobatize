import 'package:flutter/material.dart';
import 'package:jobatize_app/register/resume_processing.dart';
import 'package:jobatize_app/register/upload_resume.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProcessingScreen(fileName: '',),
    );
  }
}