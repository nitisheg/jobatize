import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login_view.dart';
import '../menu_items/go_social_and_earn.dart';
import '../menu_items/personal_details_edit.dart';
import '../menu_items/potential_job_matches.dart';
import '../menu_items/resume_improvement.dart';
import '../menu_items/upload_new_resume.dart';
import '../menu_items/view_application_sent.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final List<String> menuItems = [
    "Upload New Resume",
    "Resume Improvement",
    "View Applications Sent",
    "Potential Job Matches",
    "Personal Details",
    "Go Social & Earn",
  ];

  Widget _getScreen(String item) {
    switch (item) {
      case "Upload New Resume":
        return const UploadNewResume();
      case "Resume Improvement":
        return const ResumeImprovement();
      case "View Applications Sent":
        return const ViewApplicationSent();
      case "Potential Job Matches":
        return const PotentialJobs();
      case "Personal Details":
        return const PersonalDetailsEdit();
      case "Go Social & Earn":
        return const GoSocial();
      default:
        return const HomePageView();
    }
  }
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 8),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text("Welcome", style: TextStyle(color: Colors.black)),
            ),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2563EB)),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ...menuItems.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _getScreen(item)),
                  );
                },
              );
            }),
          ],
        ),
      ),
      body: const PotentialJobs(),
    );
  }
}
