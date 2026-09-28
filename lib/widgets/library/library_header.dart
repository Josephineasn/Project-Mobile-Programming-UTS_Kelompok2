import 'package:flutter/material.dart';

class LibraryHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddPressed;

  const LibraryHeader({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      titleSpacing: 16.0,
      title: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.black, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            'Your Library Playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: onAddPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}