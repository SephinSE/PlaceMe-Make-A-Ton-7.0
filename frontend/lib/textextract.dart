import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class PDFProcessor {
  final String convertApiSecret = 'secret_qGBWTagi91WZryAx';
  final String geminiApiKey = 'AIzaSyCuRtOFEMHCZy6ZLz3c5XMA2yzkrRmjjWw';

  Future<String?> uploadPDFAndExtractText() async {
    // Step 1: Pick a PDF file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;

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

          if (response.statusCode == 200) {
            final extractedData = json.decode(response.body);

            // Check if the response contains the file URL
            if (extractedData['Files'] != null && extractedData['Files'].isNotEmpty) {
              String textFileUrl = extractedData['Files'][0]['Url'];

              // Step 5: Fetch the content of the text file
              final textResponse = await http.get(Uri.parse(textFileUrl));

              if (textResponse.statusCode == 200) {
                return textResponse.body; // Return the extracted text
              } else {
                return 'Failed to fetch the extracted text file.';
              }
            } else {
              return 'No text found in the PDF.';
            }
          } else {
            return 'Failed to extract data from PDF. Status code: ${response.statusCode}';
          }
        } catch (e) {
          return 'Error: $e';
        }
      } else {
        return 'Failed to read file bytes.';
      }
    } else {
      return 'No file selected.';
    }
  }

  Future<String?> extractJobData(String text) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    );

    final response = await model.generateContent([
      Content.text(
        'Extract the job details from the following text in json format and add these values company_name, job_title, location, package, role_type, job_description, minimum_cgpa, number_supplies_permittable, active_backlog_allowed, service_bond, fill with n/a if not available . do not add any extra formating or the three bakctick operators just pure json file starting with bracket and ending with bracket.no extra text: $text',
      ),
    ]);

    if (response != null) {
      return response.text; // Return the extracted job details as a string
    } else {
      return 'Failed to extract job data.';
    }
  }


}
