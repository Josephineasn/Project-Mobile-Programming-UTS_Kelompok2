import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final String title;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlaylistItemTile({
    super.key,
    required this.title,
    required this.isPinned,
    required this.onTogglePin,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
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
      subtitle: Row(
        children: [
          if (isPinned) ...[
            const Icon(Icons.push_pin, color: Colors.green, size: 14),
            const SizedBox(width: 4),
          ],
          const Text(
            'Playlist • Kelompok 2',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.grey),
        color: const Color(0xFF282828),
        onSelected: (value) {
          if (value == 'pin') onTogglePin();
          if (value == 'edit') onEdit();
          if (value == 'delete') onDelete();
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'pin',
            child: Row(
              children: [
                Icon(
                  isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  isPinned ? 'Unpin playlist' : 'Pin playlist',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Edit name', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text('Delete playlist', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}