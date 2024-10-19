import 'package:flutter/material.dart';

import '../appbar/appbar.dart';
import '../appbar/navbar.dart';

class PlaceMeFeedPage extends StatelessWidget {
  const PlaceMeFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PlaceMeAppbar(
        title: 'Feed',
      ),
      body: SizedBox(height: 50),
      bottomNavigationBar: PlaceMeNavBar(),
    );
  }
}