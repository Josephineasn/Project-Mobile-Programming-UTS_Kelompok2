import 'package:flutter/material.dart';

class AddPlaylistButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddPlaylistButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black87;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Icon(
          Icons.add,
          color: titleColor,
          size: 28,
        ),
      ),
      title: Text(
        'Add Playlist',
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}