import 'package:flutter/material.dart';
import 'package:jobatize_app/providers/api_provider.dart';
import 'package:jobatize_app/register/upload_resume.dart';
import 'package:jobatize_app/services/api_service.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RegisterProvider(api: ApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobatize',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ResumeUploadScreen(),
    );
  }
}
