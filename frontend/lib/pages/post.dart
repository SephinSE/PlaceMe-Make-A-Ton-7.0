import 'dart:convert'; // For json.encode and json.decode
import 'package:flutter/material.dart'; // Flutter material design components
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../extractor.dart'; // Your custom PDFProcessor class

class PlaceMePostPage extends StatefulWidget {
  const PlaceMePostPage({super.key});

  @override
  _PlaceMePostPageState createState() => _PlaceMePostPageState();
}

class _PlaceMePostPageState extends State<PlaceMePostPage> {
  final PDFProcessor _pdfProcessor = PDFProcessor(); // Instance of your PDFProcessor
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  bool _isLoading = false;

  // Form controllers for each field
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _roleTypeController = TextEditingController();
  final TextEditingController _minimumCgpaController = TextEditingController();
  final TextEditingController _backlogController = TextEditingController();
  final TextEditingController _serviceBondController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();

  Future<void> _uploadPDFAndExtractText() async {
    setState(() {
      _isLoading = true;
    });

    // Call the upload and extraction functions
    final extractedText = await _pdfProcessor.uploadPDFAndExtractText();
    if (extractedText != null) {
      String? jobDetailsJson = await _pdfProcessor.extractJobData(extractedText);

      // Remove backticks and any leading "json" text if present
      final jsonString = jobDetailsJson?.replaceAll('json ', '').replaceAll('`', '');

      // Decode the JSON string
      final jobData = json.decode(jsonString!);

      if (jobData != null) {
        setState(() {
          // Populate the form fields with extracted job data
          _companyNameController.text = jobData['company_name'] ?? '';
          _jobTitleController.text = jobData['job_title'] ?? '';
          _locationController.text = jobData['location'] ?? '';
          _packageController.text = jobData['package'] ?? '';
          _roleTypeController.text = jobData['role_type'] ?? '';
          _minimumCgpaController.text = jobData['minimum_cgpa']?.toString() ?? '';
          _backlogController.text = jobData['active_backlog_allowed']?.toString() ?? '';
          _serviceBondController.text = jobData['service_bond'] ?? '';
          _jobDescriptionController.text = jobData['job_description'] ?? '';
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _postJobDetails() async {
    // Create a map of job details
    final jobDetails = {
    'company_name': _companyNameController.text,
    'job_title': _jobTitleController.text,
    'location': _locationController.text,
    'package': _packageController.text,
    'role_type': _roleTypeController.text,
    'minimum_cgpa': num.tryParse(_minimumCgpaController.text) ?? 0, // Convert to num
    'active_backlog_allowed': num.tryParse(_backlogController.text) ?? 0, // Convert to num
    'service_bond': _serviceBondController.text,
    'job_description': _jobDescriptionController.text,
  };

    // Add the job details to Firestore
    await _firestore.collection('post').add(jobDetails);

    // Clear the form fields
    _companyNameController.clear();
    _jobTitleController.clear();
    _locationController.clear();
    _packageController.clear();
    _roleTypeController.clear();
    _minimumCgpaController.clear();
    _backlogController.clear();
    _serviceBondController.clear();
    _jobDescriptionController.clear();

    // Optionally show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job details posted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Job Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator(), // Show loading indicator

              // Company Name field
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              const SizedBox(height: 10),

              // Job Title field
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
              ),
              const SizedBox(height: 10),

              // Location field
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 10),

              // Package field
              TextFormField(
                controller: _packageController,
                decoration: const InputDecoration(labelText: 'Package'),
              ),
              const SizedBox(height: 10),

              // Role Type field
              TextFormField(
                controller: _roleTypeController,
                decoration: const InputDecoration(labelText: 'Role Type'),
              ),
              const SizedBox(height: 10),

              // Minimum CGPA field
              TextFormField(
                controller: _minimumCgpaController,
                decoration: const InputDecoration(labelText: 'Minimum CGPA'),
              ),
              const SizedBox(height: 10),

              // Backlog Allowed field
              TextFormField(
                controller: _backlogController,
                decoration: const InputDecoration(labelText: 'Active Backlog Allowed'),
              ),
              const SizedBox(height: 10),

              // Service Bond field
              TextFormField(
                controller: _serviceBondController,
                decoration: const InputDecoration(labelText: 'Service Bond'),
              ),
              const SizedBox(height: 10),

              // Job Description field
              TextFormField(
                controller: _jobDescriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Job Description'),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _uploadPDFAndExtractText, // Disable button while loading
                child: const Text('Upload PDF and Extract Data'),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _isLoading ? null : _postJobDetails, // Disable button while loading
                child: const Text('Post Job Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _companyNameController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    _packageController.dispose();
    _roleTypeController.dispose();
    _minimumCgpaController.dispose();
    _backlogController.dispose();
    _serviceBondController.dispose();
    _jobDescriptionController.dispose();
    super.dispose();
  }
}
