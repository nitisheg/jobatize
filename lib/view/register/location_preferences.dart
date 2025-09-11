import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'agreement.dart';

class LocationPreferencesPage extends StatefulWidget {
  final Map<String, dynamic> registerData;

  const LocationPreferencesPage({super.key, required this.registerData});

  @override
  State<LocationPreferencesPage> createState() =>
      _LocationPreferencesPageState();
}

class _LocationPreferencesPageState extends State<LocationPreferencesPage> {
  String? selectedStateId;
  String? selectedCityId;
  String? jobPreference;

  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    try {
      final response = await http.get(
        Uri.parse("https://apistaging.jobatize.com/states"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          states = data
              .map<Map<String, dynamic>>(
                (item) => {
                  "id": item["id"].toString(),
                  "name": item["state"].toString(),
                },
              )
              .toList();
        });
      } else {
        debugPrint("❌ Failed to fetch states: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching states: $e");
    }
  }

  // Load cities based on state_id
  Future<void> _loadCities(String stateId) async {
    try {
      final response = await http.get(
        Uri.parse("https://appstaging.jobatize.com/city.json"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List allCities = data["cities"];

        setState(() {
          cities = allCities
              .where((city) => city["state_id"].toString() == stateId)
              .map<Map<String, dynamic>>(
                (city) => {
                  "id": city["id"].toString(),
                  "name": city["city"].toString(),
                },
              )
              .toList();

          selectedCityId = null; // reset city when state changes
        });
      } else {
        debugPrint("❌ Failed to fetch cities: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching cities: $e");
    }
  }

  void _goNext() {
    if (selectedStateId == null || selectedStateId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Please select a state")));
      return;
    }

    if (selectedCityId == null || selectedCityId!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Please select a city")));
      return;
    }

    if (jobPreference == null || jobPreference!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select a job preference")),
      );
      return;
    }

    // Find selected state & city names
    final selectedState = states.firstWhere(
      (state) => state["id"] == selectedStateId,
      orElse: () => {},
    );
    final selectedCity = cities.firstWhere(
      (city) => city["id"] == selectedCityId,
      orElse: () => {},
    );

    // Save to registerData
    widget.registerData["preferred_state_id"] = selectedStateId ?? "";
    widget.registerData["preferred_state_name"] = selectedState["name"] ?? "";
    widget.registerData["preferred_city_id"] = selectedCityId ?? "";
    widget.registerData["preferred_city_name"] = selectedCity["name"] ?? "";
    widget.registerData["apply_for_jobs_in"] = jobPreference ?? "";

    debugPrint("📍 Location Data: ${widget.registerData}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AgreementScreen(registerData: widget.registerData),
      ),
    );
  }

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
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Registration",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const SizedBox(height: 20),

                /// Progress bar
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey[300],
                  color: const Color(0xFF2563EB),
                ),
                const SizedBox(height: 20),

                /// Step Title
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

                /// State Dropdown
                DropdownButton<String>(
                  hint: const Text("Select State"),
                  value: selectedStateId,
                  isExpanded: true,
                  items: states.map<DropdownMenuItem<String>>((state) {
                    return DropdownMenuItem<String>(
                      value: state["id"].toString(),
                      child: Text(state["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStateId = value;
                      _loadCities(value!);
                    });
                  },
                ),
                const SizedBox(height: 15),

                DropdownButton<String>(
                  hint: const Text("Select City"),
                  value: selectedCityId,
                  isExpanded: true,
                  items: cities.map<DropdownMenuItem<String>>((city) {
                    return DropdownMenuItem<String>(
                      value: city["id"].toString(),
                      child: Text(city["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCityId = value;
                    });
                  },
                ),

                const SizedBox(height: 20),
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
                          setState(() => jobPreference = value),
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "Statewide",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "statewide",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value),
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "Open to Relocate (USA Wide)",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "relocate",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value),
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text(
                        "Remote",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: "remote",
                      groupValue: jobPreference,
                      onChanged: (value) =>
                          setState(() => jobPreference = value),
                      dense: true,
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
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
                      onPressed: _goNext,
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
