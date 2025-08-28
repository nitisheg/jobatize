import 'package:flutter/material.dart';
import 'package:jobatize_app/register/agreement.dart';

import 'job_title.dart';

class LocationPreferencesPage extends StatefulWidget {
  const LocationPreferencesPage({super.key});

  @override
  State<LocationPreferencesPage> createState() =>
      _LocationPreferencesPageState();
}

class _LocationPreferencesPageState extends State<LocationPreferencesPage> {
  String? selectedState;
  String? selectedCity;
  String? jobPreference;

  final List<String> states = [
    "California",
    "Texas",
    "New York",
    "Florida",
    "Illinois",
  ];

  final Map<String, List<String>> cities = {
    "California": ["Los Angeles", "San Diego", "San Jose"],
    "Texas": ["Houston", "Dallas", "Austin"],
    "New York": ["New York City", "Buffalo", "Rochester"],
    "Florida": ["Miami", "Orlando", "Tampa"],
    "Illinois": ["Chicago", "Springfield", "Naperville"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 10),              const Center(
                  child: Text(
                    "Registration",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const SizedBox(height: 20),
            
                // Progress bar
                LinearProgressIndicator(
                  value: 0.6, // Step 6/10 = 0.6
                  backgroundColor: Colors.grey[300],
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(height: 20),
            
                // Step Title
                const Text(
                  "Step 6: Location Preferences",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
            
                const Text(
                  "Tell us where you're looking for jobs.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedState,
                  decoration: const InputDecoration(
                    labelText: "Preferred Location (State/Province/Region)",
                    border: OutlineInputBorder(),
                  ),
                  items: states.map((state) {
                    return DropdownMenuItem(value: state, child: Text(state));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                      selectedCity = null;
                    });
                  },
                ),
                const SizedBox(height: 15),
            
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  decoration: const InputDecoration(
                    labelText: "Preferred Location (Town/City)",
                    border: OutlineInputBorder(),
                  ),
                  items: selectedState == null
                      ? []
                      : cities[selectedState]!
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
            
                // Radio buttons
                const Text(
                  "Apply for jobs in",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: const Text(
                        "Local Only",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "local",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value!),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true, // makes it smaller
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "Statewide",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "statewide",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value!),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "Open to Relocate (USA Wide)",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "relocate",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value!),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    RadioListTile<String>(
                      title: const Text("Remote", style: TextStyle(fontSize: 14)),
                      value: "remote",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value!),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
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
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobTitlesPage(),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
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
                            builder: (context) => AgreementScreen(),
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
