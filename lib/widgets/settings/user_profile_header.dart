import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onEditProfile;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameColor = isDark ? Colors.white : Colors.black87;
    final emailColor = isDark ? Colors.grey : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: isDark ? const Color(0xFF3E3E3E) : Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 40,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: nameColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: emailColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
            onPressed: onEditProfile,
          ),
        ],
      ),
    );
  }
}