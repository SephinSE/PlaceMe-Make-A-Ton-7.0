import 'package:flutter/material.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';

class PlaceMeCareerPage extends StatelessWidget {
  const PlaceMeCareerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PlaceMeAppbar(
        title: 'Career',
      ),
      body: SizedBox(height: 50),
      bottomNavigationBar: PlaceMeNavBar(),
    );
  }
}