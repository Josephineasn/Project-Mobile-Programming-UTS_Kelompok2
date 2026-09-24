import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? avatarUrl;
  final VoidCallback? onEditProfile;

  const UserProfileHeader({
    super.key,
    required this.userName,
    required this.userEmail,
    this.avatarUrl,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade800,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white70,
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onEditProfile != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white70),
              onPressed: onEditProfile,
              tooltip: 'Edit Profile',
            ),
        ],
      ),
    );
  }
}