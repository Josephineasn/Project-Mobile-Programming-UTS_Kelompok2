import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../screens/settings_screen.dart';

class HeaderGreetingWidget extends StatelessWidget {
  final String salam;
  final String? profileImageUrl;

  const HeaderGreetingWidget({
    super.key,
    required this.salam,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryGreen,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : null,
            child: profileImageUrl == null
                ? const Icon(Icons.person, size: 20, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              salam,
              style: TextStyle(
                color: contentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            icon: Icon (Icons.notifications_none, color: contentColor, size: 24),
            onPressed: () {},
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            icon: Icon (Icons.history, color: contentColor, size: 24),
            onPressed: () {},
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 6),
            icon: Icon (Icons.settings_outlined, color: contentColor, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}