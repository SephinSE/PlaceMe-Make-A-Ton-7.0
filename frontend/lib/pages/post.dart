import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class PlaceMePostPage extends StatefulWidget {
  const PlaceMePostPage({super.key});

  @override
  _PlaceMePostPageState createState() => _PlaceMePostPageState();
}

class _PlaceMePostPageState extends State<PlaceMePostPage> {
  String? _jobDetails;
  String? _extractedText;
  bool _isLoading = false;

  final String convertApiSecret = 'secret_qGBWTagi91WZryAx'; // Replace with your Convert API Secret
  final String geminiApiKey = 'AIzaSyCuRtOFEMHCZy6ZLz3c5XMA2yzkrRmjjWw'; // Your Gemini API Key

  Future<void> _uploadPDFAndExtractText() async {
  setState(() {
    _isLoading = true; // Show loading indicator
  });

  // Step 1: Pick a PDF file
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.isNotEmpty) {
    final fileBytes = result.files.first.bytes;

    // Debugging: Confirm that the file was picked
    print('PDF file picked: ${result.files.first.name}');

    if (fileBytes != null) {
      try {
        // Step 2: Encode the PDF file to Base64
        String base64EncodedFile = base64Encode(fileBytes);

        // Step 3: Prepare the request body
        final requestBody = json.encode({
          "Parameters": [
            {
              "Name": "File",
              "FileValue": {
                "Name": result.files.first.name,
                "Data": base64EncodedFile,
              },
            },
            {
              "Name": "StoreFile",
              "Value": true,
            },
          ],
        });

        // Step 4: Send the request to the Convert API
        final uri = Uri.parse('https://v2.convertapi.com/convert/pdf/to/txt');
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $convertApiSecret',
            'Content-Type': 'application/json',
          },
          body: requestBody,
        );

        // Debugging: Log response status
        print('Convert API response status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final extractedData = json.decode(response.body);

          // Debugging: Log the entire response data
          print('Response from Convert API: $extractedData');

          // Check if the response contains the file URL
          if (extractedData['Files'] != null && extractedData['Files'].isNotEmpty) {
            String textFileUrl = extractedData['Files'][0]['Url'];

            // Debugging: Log the URL of the extracted text file
            print('Extracted Text File URL: $textFileUrl');

            // Step 5: Fetch the content of the text file
            final textResponse = await http.get(Uri.parse(textFileUrl));

            if (textResponse.statusCode == 200) {
              setState(() {
                _extractedText = textResponse.body; // Set the extracted text
                print('Extracted Text: $_extractedText'); // Log the extracted text
              });

              // Proceed to extract job details from the extracted text
              await _extractJobData(_extractedText!);
            } else {
              setState(() {
                _extractedText = 'Failed to fetch the extracted text file.';
              });
              print('Error fetching the extracted text file: ${textResponse.statusCode}');
            }
          } else {
            setState(() {
              _extractedText = 'No text found in the PDF.';
            });
            print('No text found in the PDF.'); // Log this case
          }
        } else {
          final responseData = response.body; // Read response body for more details
          setState(() {
            _extractedText = 'Failed to extract data from PDF. Status code: ${response.statusCode}';
          });
          print('Error: ${response.statusCode} - ${response.reasonPhrase}'); // Log the error
          print('Response body: $responseData'); // Log the response body for more details
        }
      } catch (e) {
        setState(() {
          _extractedText = 'Error: $e';
        });
        print('Exception: $e'); // Log any exceptions
      }
    } else {
      setState(() {
        _extractedText = 'Failed to read file bytes.';
      });
      print('Failed to read file bytes.'); // Log this case
    }
  } else {
    setState(() {
      _extractedText = 'No file selected.';
    });
    print('No file selected.'); // Log this case
  }

  setState(() {
    _isLoading = false; // Hide loading indicator
  });
}


  Future<void> _extractJobData(String text) async {
    // Create the model for Gemini API
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    );

    // Send the extracted text to the Gemini API for job data extraction
    final response = await model.generateContent([
      Content.text('Extract the job details from the following text in json format and add these values company_name, job_title,location,package,role_type,job_description,minimum_cgpa,number_supplies_permittable,active_backlog_allowed,service_bond,fill with n/a if not available: $text')
    ]);

    if (response != null) {
      final responseText = response.text; // Access the response text directly
      setState(() {
        _jobDetails = responseText; // Set the extracted job details
        print('Extracted Job Details: $_jobDetails'); // Log the extracted job details
      });
    } else {
      setState(() {
        _jobDetails = 'Failed to extract job data.';
      });
      print('Failed to extract job data.'); // Log this case
    }
  }
    String _formatJobDetails(String jsonResponse) {
    try {
      final jobData = json.decode(jsonResponse);
      // Create a formatted string
      return '''
      Company Name: ${jobData['company_name']}
      Job Title: ${jobData['job_title']}
      Location: ${jobData['location']}
      Package: ${jobData['package']}
      Role Type: ${jobData['role_type']}
      Minimum CGPA: ${jobData['minimum_cgpa']}
      Active Backlog Allowed: ${jobData['active_backlog_allowed']}
      Service Bond: ${jobData['service_bond']}
      ''';
    } catch (e) {
      print("Error formatting job details: $e");
      return 'Failed to format job details';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(), // Show loading indicator
              
              if (_jobDetails != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Job Details: $_jobDetails',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadPDFAndExtractText, // Disable button while loading
                child: const Text('Upload PDF and Extract Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
