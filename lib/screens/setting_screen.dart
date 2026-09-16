import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Profile & Settings'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget 1
            UserProfileHeader(),
            SizedBox(height: 16),

            // Widget 2
            PlanStatusCard(),
            SizedBox(height: 16),

            // Widget 3
            AccountSettingTile(),
            SizedBox(height: 16),

            // Widget 4
            ThemeToggleSwitch(),
            SizedBox(height: 16),

            // Widget 5
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}

// --- Kerangka Kosong 5 Widget ---

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('1. UserProfileHeader', style: TextStyle(color: Colors.white));
  }
}

class PlanStatusCard extends StatelessWidget {
  const PlanStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('2. PlanStatusCard', style: TextStyle(color: Colors.white));
  }
}

class AccountSettingTile extends StatelessWidget {
  const AccountSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('3. AccountSettingTile', style: TextStyle(color: Colors.white));
  }
}

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('4. ThemeToggleSwitch', style: TextStyle(color: Colors.white));
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('5. LogoutButton', style: TextStyle(color: Colors.white));
  }
}