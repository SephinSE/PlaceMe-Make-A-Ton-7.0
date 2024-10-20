import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../appbar/appbar.dart';
import '../appbar/navbar.dart';

class PlaceMeFeedPage extends StatefulWidget {
  const PlaceMeFeedPage({super.key});

  @override
  State<PlaceMeFeedPage> createState() => _PlaceMeFeedPageState();
}

class _PlaceMeFeedPageState extends State<PlaceMeFeedPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;

  // Assuming user's CGPA is fetched from some logic, hardcoded for now
  final double userCGPA = 9; // Example CGPA

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    // Fetching data from the 'post' collection
    final querySnapshot = await _firestore
        .collection('post')
        .where('minimum_cgpa', isLessThanOrEqualTo: userCGPA) // Filter by CGPA
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("No posts found.");
    } else {
      for (var doc in querySnapshot.docs) {
        print("Fetched Post: ${doc.data()}"); // Print the fetched data
        _posts.add(doc);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PlaceMeAppbar(title: 'Feed'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index].data() as Map<String, dynamic>;
                final companyName = post['company_name'] ?? 'Unknown Company';
                final jobTitle = post['job_title'] ?? 'Unknown Title';
                final jobDescription = post['job_description'] ?? 'No Description';
                final location = post['location'] ?? 'Unknown Location';
                final minCGPA = (post['minimum_cgpa'] ?? 0.0).toDouble();
                final package = post['package'] ?? 'N/A';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(companyName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text('Job Title: $jobTitle'),
                        Text('Description: $jobDescription'),
                        Text('Location: $location'),
                        Text('Minimum CGPA: $minCGPA'),
                        Text('Package: $package LPA'),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const PlaceMeNavBar(),
    );
  }
}
