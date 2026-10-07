import 'package:flutter/material.dart';

class LibraryHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddPressed;
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  const LibraryHeader({
    super.key,
    required this.onAddPressed,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: isSearching
          ? TextField(
              autofocus: true,
              style: TextStyle(color: contentColor),
              decoration: InputDecoration(
                hintText: 'Search your library...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF1DB954),
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Your Library Playlist',
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
      actions: [
        IconButton(
          icon: Icon(
            isSearching ? Icons.close : Icons.search,
            color: contentColor,
          ),
          onPressed: onSearchToggle,
        ),
        if (!isSearching)
          IconButton(
            icon: Icon(Icons.add, color: contentColor),
            onPressed: onAddPressed,
          ),
      ],
    );
  }
}
