import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final int index;
  
  const PlaylistItemTile({
    super.key, 
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Gambar Kotak Playlist (Placeholder)
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.music_note, color: Colors.grey, size: 30),
      ),
      // Judul Playlist
      title: Text(
        'Playlist Musik #${index + 1}',
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 16, 
          fontWeight: FontWeight.w500,
        ),
      ),
      // Subtitle dengan Ikon Pin
      subtitle: Row(
        children: const [
          Icon(Icons.push_pin, color: Colors.green, size: 14), 
          SizedBox(width: 4),
          Text(
            'Playlist • Kelompok 2', 
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
      onTap: () {
        // Aksi saat playlist ditekan nanti
      },
    );
  }
}