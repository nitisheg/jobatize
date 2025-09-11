import 'package:flutter/material.dart';

class ResumeImprovement extends StatelessWidget {
  const ResumeImprovement({super.key});

  Widget _buildImprovementCard({
    required Color bgColor,
    required String title,
    required String description,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: bgColor.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: bgColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Resume Improvement"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Resume Improvement",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Get personalized suggestions to enhance your resume and stand out to recruiters.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _buildImprovementCard(
              bgColor: Color(0xFF2563EB),
              title: "AI-Powered Analysis",
              description:
                  "Upload your resume for an instant analysis of keywords, formatting, and impact.",
              buttonText: "Analyze My Resume",
              buttonColor: Color(0xFF2563EB),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Analyze Resume Clicked")),
                );
              },
            ),
            _buildImprovementCard(
              bgColor: Color(0xFF16A34A),
              title: "Expert Tips & Guides",
              description:
                  "Access curated resources and articles on crafting a compelling resume.",
              buttonText: "Browse Guides",
              buttonColor: Color(0xFF16A34A),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Browse Guides Clicked")),
                );
              },
            ),
            _buildImprovementCard(
              bgColor: Color(0xFF9333EA),
              title: "One-on-One Coaching",
              description:
                  "Schedule a session with a career expert for personalized resume feedback.",
              buttonText: "Book a Session",
              buttonColor: Color(0xFF9333EA),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Book a Session Clicked")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
