import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final VoidCallback onEditProfile;
  final bool isPrivateSession;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onEditProfile,
    this.isPrivateSession = false,
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
          Stack(
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
              // Activity Status Indicator
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isPrivateSession ? Colors.grey : const Color(0xFF1DB954),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF121212) : Colors.white,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            ],
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