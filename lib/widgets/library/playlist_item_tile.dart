import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final String title;
  final VoidCallback? onLongPress;

  const PlaylistItemTile({
    super.key,
    required this.title,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      onLongPress: onLongPress,
      leading: Container(
        width: 48,
        height: 48,
        color: Colors.grey[800],
        child: const Icon(Icons.music_note, color: Colors.grey),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: const Row(
        children: [
          Icon(Icons.push_pin, color: Colors.green, size: 14),
          SizedBox(width: 4),
          Text(
            'Playlist • Kelompok 2',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}