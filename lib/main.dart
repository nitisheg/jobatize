import 'package:flutter/material.dart';
import 'package:jobatize_app/view/home_page/home_page_view.dart';
import 'package:jobatize_app/view/login/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/api_provider.dart';
import 'core/services/api_service.dart';

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
  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jobatize',
      theme: ThemeData(primarySwatch: Colors.blue),

      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data == true) {
            return const HomePageView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
