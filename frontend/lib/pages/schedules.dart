import 'package:flutter/material.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';

class PlaceMeSchedulesPage extends StatelessWidget {
  const PlaceMeSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PlaceMeAppbar(
        title: 'Schedules',
      ),
      body: SizedBox(height: 50),
      bottomNavigationBar: PlaceMeNavBar(),
    );
  }
}