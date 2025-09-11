import 'package:flutter/material.dart';
import 'package:jobatize_app/view/register/set_password.dart';

class AgreementScreen extends StatefulWidget {
  final Map<String, dynamic> registerData; // ✅ pass register data

  const AgreementScreen({super.key, required this.registerData});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool termsAccepted = false;
  bool privacyAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey.shade300,
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Step 7: Agreement",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please read and agree to our terms and policies to complete registration.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  thickness: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 4),
                    child: SingleChildScrollView(
                      child: const Text(
                        """Job Buddie Terms and Conditions (Sample)\n
Welcome to Job Buddie! By Welcome to Job Buddie! By using our website and services, you agree to comply with and be bound by the following terms and conditions. Please review them carefully.

1. Acceptance of Terms
By accessing or using Job Buddie, you agree to these Terms and Conditions and our Privacy Policy. If you do not agree, you may not use our services.

2. User Accounts
You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.

3. Use of Service
You agree to use Job Buddie only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else's use and enjoyment of the website.

4. Resume Parsing
By uploading your resume, you consent to our use of parsing technology to extract information for the purpose of creating your profile and matching you with job opportunities.

5. Disclaimer
Job Buddie provides job listings and career resources for informational purposes only. We do not guarantee the accuracy, completeness, or suitability of any job listing or other content.

6. Changes to Terms
We reserve the right to modify these terms at any time. Your continued use of the site after changes constitutes your acceptance of the new terms.

Job Buddie Privacy Policy (Sample)
Your privacy is important to us. This policy explains how we collect, use, and protect your personal information.

1. Information Collection
We collect information you provide directly to us, such as when you create an account, upload a resume, or apply for a job. This includes personal details, work history, education, and contact information.

2. Use of Information
We use your information to provide and improve our services, including: creating and managing your profile, parsing your resume, matching you with relevant jobs, communicating with you, and analyzing usage to enhance the website.

3. Information Sharing
We may share your information with potential employers when you apply for a job. We do not sell your personal information to third parties. We may share data with service providers who help us operate the website, under strict confidentiality agreements.

4. Data Security
We implement reasonable security measures to protect your personal information from unauthorized access, disclosure, alteration, and destruction.

5. Your Choices
You can access, update, or delete your personal information through your account settings. You can also opt out of receiving promotional communications.

6. Contact Us
If you have questions about this privacy policy, please contact us at [Your Contact Email].""",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                value: termsAccepted,
                onChanged: (value) {
                  setState(() => termsAccepted = value!);
                  print("✅ Terms Accepted: $termsAccepted");
                },
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I have read and agree to the Terms and Conditions",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CheckboxListTile(
                value: privacyAccepted,
                onChanged: (value) {
                  setState(() => privacyAccepted = value!);
                  print("✅ Privacy Accepted: $privacyAccepted");
                },
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "I have read and agree to the Privacy Policy",
                  style: TextStyle(fontSize: 14),
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
                      if (!termsAccepted || !privacyAccepted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "You must agree to Terms and Privacy Policy to continue.",
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      widget.registerData['agreed_terms'] = true;
                      widget.registerData['agreed_privacy'] = true;

                      debugPrint("📍 Location Data: ${widget.registerData}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetPassword(
                            registerData: widget.registerData,
                            token: '',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Finish",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
