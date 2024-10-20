import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';
import 'feed.dart';

class PlaceMePostPage extends StatefulWidget {
  const PlaceMePostPage({super.key});

  @override
  State<PlaceMePostPage> createState() => _PlaceMePostPageState();
}

class _PlaceMePostPageState extends State<PlaceMePostPage> {
  final TextEditingController _controllerCompanyName = TextEditingController();
  final TextEditingController _controllerRoleName = TextEditingController();
  final TextEditingController _controllerCTC = TextEditingController();
  final TextEditingController _controllerRoleType = TextEditingController();
  final TextEditingController _controllerLocation = TextEditingController();
  final TextEditingController _controllerMinCGPA = TextEditingController();
  final TextEditingController _controllerBranches = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersistentBottomSheet();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPersistentBottomSheet();
    });
  }

  Future<void> _post() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      // Store data to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'companyName': _controllerCompanyName.text,
        'roleName': _controllerRoleName.text,
        'roleType': _controllerRoleType.text,
        'location': _controllerLocation.text,
        'ctc': _controllerCTC,
        'minCGPA': _controllerMinCGPA,
        'branches': _controllerBranches,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Post uploaded successfully'),
      ));
      setState(() {
        _controllerRoleType.clear();
        _controllerCTC.clear();
        _controllerRoleName.clear();
        _controllerCompanyName.clear();
        _controllerMinCGPA.clear();
        _controllerLocation.clear();
        _controllerBranches.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload post: $e'),
      ));
    }
  }

  void _showPersistentBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet((BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6, // 60% of the screen height
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                      // Navigate to ThistleFeedPage in the next frame
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const PlaceMeFeedPage()),
                        );
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 20, width: 180),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Company Name'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerCompanyName,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Role'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerRoleName,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Role Type'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerRoleType,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('CTC'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerCTC,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Location'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerLocation,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Minimum CGPA'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerMinCGPA,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Eligible Branches'),
                  const SizedBox(width: 50),
                  TextField(
                    controller: _controllerBranches,
                    decoration: const InputDecoration(labelText: 'enter company name'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _post,
                child: const Text('Post'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const PlaceMeAppbar(
        title: 'Post',
      ),
      body: const Center(
        child: Text(''),
      ),
      bottomNavigationBar: const PlaceMeNavBar(),
    );
  }
}
