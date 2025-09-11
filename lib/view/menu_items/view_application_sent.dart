import 'package:flutter/material.dart';

class ViewApplicationSent extends StatelessWidget {
  const ViewApplicationSent({super.key});

  final List<Map<String, String>> applications = const [
    {
      "jobTitle": "Software Engineer",
      "company": "Tech Innovators Inc.",
      "dateApplied": "2025-05-10",
      "status": "Pending",
    },
    {
      "jobTitle": "Marketing Manager",
      "company": "Global Brands Co.",
      "dateApplied": "2025-04-25",
      "status": "Reviewed",
    },
    {
      "jobTitle": "Data Analyst",
      "company": "Data Insights Ltd.",
      "dateApplied": "2025-04-01",
      "status": "Rejected",
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.amber.shade600;
      case "Reviewed":
        return Colors.green.shade500;
      case "Rejected":
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Applications Sent"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8),
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
                      app["jobTitle"] ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      app["company"] ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              app["dateApplied"] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              app["status"] ?? "",
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            app["status"] ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(app["status"] ?? ""),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
