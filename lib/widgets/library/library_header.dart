import 'package:flutter/material.dart';

class LibraryHeader extends StatelessWidget implements PreferredSizeWidget {
  final Function() onAddPressed;
  final bool isSearching;
  final Function() onSearchToggle;
  final Function(String) onSearchChanged;

  const LibraryHeader({
    super.key,
    required this.onAddPressed,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      titleSpacing: 16.0,
      title: isSearching
          ? TextField(
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search playlist...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : const Row(
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
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: onSearchToggle,
        ),
        if (!isSearching)
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