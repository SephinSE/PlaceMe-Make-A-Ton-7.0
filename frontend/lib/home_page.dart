import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import './pages/feed.dart';
import '../pages/career.dart';
import '../pages/post.dart';
import '../pages/schedules.dart';
import '../pages/profile.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });

  final List<Widget> pages =  const [
    PlaceMeFeedPage(),
    PlaceMeSchedulesPage(),
    PlaceMeCareerPage(),
    PlaceMeProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return pages[context.watch<ApplicationState>().selectedIndex];
  }
}
