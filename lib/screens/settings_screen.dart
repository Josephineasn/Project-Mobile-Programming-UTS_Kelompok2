import 'package:flutter/material.dart';
import '../widgets/settings/user_profile_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          UserProfileHeader(
            userName: 'John Doe',
            userEmail: 'johndoe@example.com',
            onEditProfile: () {},
          ),
        ],
      ),
    );
  }
}