import 'package:flutter/material.dart';
import '../widgets/library/playlist_item_tile.dart';
import '../widgets/library/library_header.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  String selectedFilter = '';

  List<String> playlists = [
    'Playlist Musik #1',
    'Playlist Musik #2',
    'Playlist Musik #3',
  ];

  // Dialog Tambah Playlist
  void showCreatePlaylistDialog() {
    final controller = TextEditingController(
      text: 'Playlist Baru #${playlists.length + 1}',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Beri nama playlist-mu', style: TextStyle(color: Colors.white, fontSize: 18)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    playlists.add(text);
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Buat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus Playlist
  void showDeletePlaylistDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Hapus Playlist?', style: TextStyle(color: Colors.white, fontSize: 18)),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${playlists[index]}"?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  playlists.removeAt(index);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // Panggil LibraryHeader yang sudah dipisah
      appBar: LibraryHeader(
        onAddPressed: showCreatePlaylistDialog,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                ChoiceChip(
                  shape: const StadiumBorder(),
                  side: BorderSide.none,
                  label: Text(
                    'Playlists',
                    style: TextStyle(color: selectedFilter == 'Playlists' ? Colors.black : Colors.white),
                  ),
                  selected: selectedFilter == 'Playlists',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[900],
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() => selectedFilter = selected ? 'Playlists' : '');
                  },
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  shape: const StadiumBorder(),
                  side: BorderSide.none,
                  label: Text(
                    'Artist',
                    style: TextStyle(color: selectedFilter == 'Artist' ? Colors.black : Colors.white),
                  ),
                  selected: selectedFilter == 'Artist',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[900],
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() => selectedFilter = selected ? 'Artist' : '');
                  },
                ),
              ],
            ),
          ),

          // Daftar Playlist dengan Hold to Delete
          Expanded(
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return PlaylistItemTile(
                  title: playlists[index],
                  onLongPress: () => showDeletePlaylistDialog(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}