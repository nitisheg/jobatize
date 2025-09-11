import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class UploadNewResume extends StatefulWidget {
  const UploadNewResume({super.key});

  @override
  State<UploadNewResume> createState() => _UploadNewResumeState();
}

class _UploadNewResumeState extends State<UploadNewResume> {
  File? selectedFile;
  bool isUploading = false;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-api-url.com", // 🔹 Change to your backend URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file first")),
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      String fileName = selectedFile!.path.split("/").last;

      FormData formData = FormData.fromMap({
        "resume": await MultipartFile.fromFile(
          selectedFile!.path,
          filename: fileName,
        ),
        "userId": "123", // 🔹 Example, replace with logged-in user ID
      });

      Response response = await _dio.post(
        "/candidate/upload-resume", // 🔹 Your API endpoint
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer YOUR_TOKEN_HERE", // 🔹 If needed
          },
        ),
        onSendProgress: (count, total) {
          debugPrint("Progress: ${(count / total * 100).toStringAsFixed(0)}%");
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume uploaded successfully ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.statusMessage}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Upload New Resume"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Upload New Resume",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Easily upload your latest resume to keep your profile updated.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        selectedFile == null
                            ? "Click to select a resume file"
                            : selectedFile!.path.split('/').last,
                        style: TextStyle(
                          color: selectedFile == null
                              ? Color(0xFF2563EB)
                              : Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "PDF, DOC, DOCX files supported. Max 5MB.",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isUploading ? null : _uploadFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Upload Resume",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
