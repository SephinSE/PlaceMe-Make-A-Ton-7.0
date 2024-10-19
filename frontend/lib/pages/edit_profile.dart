import 'package:flutter/material.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';

class PlaceMeEditProfilePage extends StatelessWidget {
  const PlaceMeEditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PlaceMeAppbar(
        title: 'Edit Profile',
      ),
      body: SizedBox(height: 50),
      bottomNavigationBar: PlaceMeNavBar(),
    );
  }
}