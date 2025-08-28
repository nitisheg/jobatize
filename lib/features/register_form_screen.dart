// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../providers/api_provider.dart';
//
// class RegisterFormScreen extends StatelessWidget {
//   const RegisterFormScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final prov = context.watch<RegisterProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Complete Registration")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             TextField(controller: prov.fullNameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
//             TextField(controller: prov.emailCtrl, decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: prov.phoneCtrl, decoration: const InputDecoration(labelText: "Phone")),
//             TextField(controller: prov.passwordCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//             const SizedBox(height: 10),
//             Row(children: [
//               Checkbox(value: prov.agreedTerms, onChanged: (v) { prov.agreedTerms = v!; prov.notifyListeners(); }),
//               const Text("Agree Terms"),
//             ]),
//             Row(children: [
//               Checkbox(value: prov.agreedPrivacy, onChanged: (v) { prov.agreedPrivacy = v!; prov.notifyListeners(); }),
//               const Text("Agree Privacy"),
//             ]),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final res = await prov.registerUser();
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered!")));
//                     Navigator.popUntil(context, (r) => r.isFirst);
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//                 }
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
