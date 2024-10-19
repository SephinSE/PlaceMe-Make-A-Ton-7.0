import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../appbar/appbar.dart';
import '../appbar/navbar.dart';
import 'edit_profile.dart';

class PlaceMeProfilePage extends StatelessWidget {
  const PlaceMeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    void navigateToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlaceMeEditProfilePage()),
      );
    }

    return Scaffold(
      appBar: const PlaceMeAppbar(
        title: 'Profile',
      ),
      body: const SizedBox(height: 50),
      bottomNavigationBar: const PlaceMeNavBar(),
      endDrawer: MyDrawer(
        //onSignOutTap: Provider.of<ApplicationState>(context, listen: false).signOut,
        onSettingsTap: navigateToEditProfile,
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    //required this.onSignOutTap,
    required this.onSettingsTap,
  });

  //final void Function()? onSignOutTap;
  final void Function()? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF342E5B),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              size: 64,
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onTap: onSettingsTap,
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white), // Optional: Style the text
            ),
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.logout,
          //     color: Colors.white,
          //   ),
          //   onTap: onSignOutTap,
          //   title: const Text(
          //     'Sign Out',
          //     style: TextStyle(color: Colors.white), // Optional: Style the text
          //   ),
          // ),
        ],
      ),
    );
  }
}