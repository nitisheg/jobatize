import 'package:flutter/material.dart';
import 'location_preferences.dart';

class SuggestedJobTitlesScreen extends StatefulWidget {
  final Map<String, dynamic> registerData; // ✅ keep register data

  const SuggestedJobTitlesScreen({super.key, required this.registerData});

  @override
  State<SuggestedJobTitlesScreen> createState() =>
      _SuggestedJobTitlesScreenState();
}

class _SuggestedJobTitlesScreenState extends State<SuggestedJobTitlesScreen> {
  final TextEditingController _titleController = TextEditingController();

  List<Map<String, dynamic>> jobTitles = [];

  void _addJobTitle() {
    if (_titleController.text.trim().isNotEmpty) {
      setState(() {
        jobTitles.add({
          "title": _titleController.text.trim(),
          "desc": "Manually added title.",
          "selected": false,
        });
        _titleController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final suggestedJobTitles =
        (widget.registerData["suggested_job_titles"] as List<dynamic>? ??
                widget.registerData["suggestedJobTitles"] as List<dynamic>? ??
                [])
            .map((e) => e.toString())
            .toList();

    final allTitles = {...suggestedJobTitles}.toList();

    jobTitles = [
      ...allTitles.map(
        (title) => {
          "title": title,
          "desc": "Extracted from CV",
          "selected": true,
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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

                const Center(
                  child: Text(
                    "Registration",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Step 5: Suggested Job Titles",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Select the job titles you are interested in, or add your own. Suggested titles are pre-selected.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                if (jobTitles.isEmpty)
                  const Text(
                    "No suggested titles found. Please add manually.",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ...jobTitles.map(
                  (job) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CheckboxListTile(
                      value: job["selected"],
                      onChanged: (val) {
                        setState(() {
                          job["selected"] = val ?? false;
                        });
                      },
                      title: Text(
                        job["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(job["desc"]),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Add Another Title of Interest",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "e.g., Data Scientist",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                const SizedBox(height: 2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final suggestedJobTitles = jobTitles
                            .where((job) => job["suggested_job_titles"] == true)
                            .map(
                              (job) => job["suggested_job_titles"].toString(),
                            )
                            .toList();

                        widget.registerData["suggested_job_titles"] =
                            suggestedJobTitles;
                        debugPrint(
                          "Final selected jobTitles: $suggestedJobTitles",
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationPreferencesPage(
                              registerData: widget.registerData,
                            ),
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
