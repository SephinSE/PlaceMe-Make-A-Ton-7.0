import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';

import '../styles.dart';

class PlaceMeNavBar extends StatefulWidget{
  const PlaceMeNavBar({super.key});

  @override
  State<PlaceMeNavBar> createState() => _PlaceMeNavBarState();
}

class _PlaceMeNavBarState extends State<PlaceMeNavBar> {
  @override
  Widget build(BuildContext context) {
    Color color = AppStyles.placeMeColor;
    bool isAdmin = true;

    return NavigationBar(
      destinations: [
        NavigationDestination(icon: Icon(Icons.home, color: color), label: 'Feed'),
        isAdmin ? NavigationDestination(icon: Icon(Icons.add_box, color: color), label: 'Post') : NavigationDestination(icon: Icon(Icons.location_on, color: color), label: 'Schedules'),
        NavigationDestination(icon: Icon(Icons.favorite, color: color), label: 'Career'),
        NavigationDestination(icon: Icon(Icons.person, color: color), label: 'Profile'),
      ],
      backgroundColor: AppStyles.onPlaceMeColor,
      selectedIndex: Provider.of<ApplicationState>(context).selectedIndex,
      onDestinationSelected: Provider.of<ApplicationState>(context, listen: false).onNavBarTap,
    );
  }
}