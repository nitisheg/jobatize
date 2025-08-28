import 'package:flutter/material.dart';
import 'package:jobatize_app/register/personal_details.dart';
import 'package:jobatize_app/register/suggested_job_title.dart';

class JobTitlesPage extends StatefulWidget {
  const JobTitlesPage({super.key});

  @override
  State<JobTitlesPage> createState() => _JobTitlesPageState();
}

class _JobTitlesPageState extends State<JobTitlesPage> {
  late TextEditingController jobController; // declare controller
  List<String> jobTitles = ["Intern"];

  @override
  void initState() {
    super.initState();
    jobController = TextEditingController();
  }

  @override
  void dispose() {
    jobController.dispose(); // dispose controller to avoid memory leaks
    super.dispose();
  }

  void _addJobTitle() {
    if (jobController.text.trim().isNotEmpty) {
      setState(() {
        jobTitles.add(jobController.text.trim());
        jobController.clear();
      });

      // Success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Job title added successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 40, right: 20),
          dismissDirection: DismissDirection.up,
        ),
      );
    }
  }

  void _removeJobTitle(String title) {
    setState(() {
      jobTitles.remove(title);
    });

    // Error Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$title removed"),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 40, right: 20),
        dismissDirection: DismissDirection.up,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Registration",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: 0.4,
                  backgroundColor: Colors.grey.shade300,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 4: Confirm Previous Job Titles",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Review and edit your past job titles.",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 16),

                // Job Titles List
                Column(
                  children: jobTitles.map((title) {
                    return ListTile(
                      title: Text(title),
                      trailing: TextButton(
                        onPressed: () => _removeJobTitle(title),
                        child: const Text(
                          "Remove",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: jobController,
                  decoration: InputDecoration(
                    hintText: "e.g., Software Engineer",
                    labelText: "Add Another Job Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF16A34A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _addJobTitle,
                    child: const Text(
                      "Add Title",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 24,
                    //       vertical: 12,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     if (Navigator.canPop(context)) {
                    //       Navigator.pop(context);
                    //     } else {
                    //       // Handle case: maybe go to home or upload screen
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => PersonalDetails(
                    //             token: '',
                    //             fullNameCtrl: '',
                    //             emailCtrl: '',
                    //             phoneCtrl: '',
                    //             currentCityCtrl: '',
                    //             currentStateCtrl: '',
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //   },
                    //   child: const Text(
                    //     "Back",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuggestedJobTitlesScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
