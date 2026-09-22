import 'package:flutter/material.dart';
import '../widgets/settings/user_profile_header.dart';
import '../widgets/settings/account_setting_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          UserProfileHeader(
            userName: 'John Doe',
            userEmail: 'johndoe@example.com',
            onEditProfile: () {},
          ),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),

          // Komponen AccountSettingTile
          AccountSettingTile(
            icon: Icons.person_outline,
            title: 'Account',
            subtitle: 'Username, email, connected accounts',
            onTap: () {},
          ),
          AccountSettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Push notifications, email updates',
            onTap: () {},
          ),
          AccountSettingTile(
            icon: Icons.volume_up_outlined,
            title: 'Audio Quality',
            subtitle: 'Streaming and download settings',
            onTap: () {},
          ),
          AccountSettingTile(
            icon: Icons.shield_outlined,
            title: 'Privacy & Social',
            subtitle: 'Listening activity, private session',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}