import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final String title;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PlaylistItemTile({
    super.key,
    required this.title,
    required this.isPinned,
    required this.onTogglePin,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

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
          Icons.music_note,
          color: isDark ? Colors.grey : Colors.grey.shade700,
          size: 28,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Row(
        children: [
          if (isPinned) ...[
            const Icon(Icons.push_pin, color: Color(0xFF1DB954), size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            'Playlist • Kelompok 2',
            style: TextStyle(
              color: subColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: subColor),
        color: isDark ? const Color(0xFF282828) : Colors.white,
        onSelected: (value) {
          if (value == 'pin') {
            onTogglePin();
          } else if (value == 'edit') {
            onEdit();
          } else if (value == 'delete') {
            onDelete();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'pin',
            child: Text(
              isPinned ? 'Lepas Sematan' : 'Sematkan Playlist',
              style: TextStyle(color: titleColor),
            ),
          ),
          PopupMenuItem(
            value: 'edit',
            child: Text(
              'Edit Nama',
              style: TextStyle(color: titleColor),
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
      onTap: onTap, // 3. Menghubungkan onTap bawaan ListTile ke parameter onTap
    );
  }
}