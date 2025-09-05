import 'package:flutter/material.dart';
import 'package:jobatize_app/login/login_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  String _selectedMenu = "Potential Job Matches";
  final List<String> menuItems = [
    "Upload New Resume",
    "Resume Improvement",
    "View Applications Sent",
    "Potential Job Matches",
    "Personal Details",
    "Go Social & Earn",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
            },
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
                selected: _selectedMenu == item,
                selectedTileColor: Colors.blue.shade100,
                onTap: () {
                  setState(() {
                    _selectedMenu = item;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedMenu,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedMenu == "Potential Job Matches"
                      ? "Here are some job opportunities that match your skills and preferences."
                      : "Content for $_selectedMenu will appear here.",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
