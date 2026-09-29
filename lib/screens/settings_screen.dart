import 'package:flutter/material.dart';
import '../widgets/settings/user_profile_header.dart';
import '../widgets/settings/account_setting_tile.dart';
import '../widgets/settings/plan_status_card.dart';
import '../widgets/settings/logout_button.dart';
import '../screens/premium_screen.dart';
import '../widgets/settings/theme_toggle_switch.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

          PlanStatusCard(
            planName: 'Melodix Free', // masih bisa di ubah teksnya
            planDescription: 'Enjoy music with ad breaks. Upgrade to get unlimited and offline listening.' ,
            isPremium: false,
            onUpgradePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumScreen()
                ),
              );
            }, // dalam proses
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
          
          ThemeToggleSwitch(
            initialValue: themeNotifier.value == ThemeMode.dark,
            onToggle: (isDark) {
              themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isDark ? 'Dark mode is activated' : 'Light mode is activated',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),

          LogoutButton(
            onLogout: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully logged out'))
              );
            },
          ),
        ],
      ),
    );
  }
}