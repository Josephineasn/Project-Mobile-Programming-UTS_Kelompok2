import 'package:flutter/material.dart';
import '../widgets/library/playlist_item_tile.dart';
import '../widgets/library/library_header.dart';
import '../widgets/library/filter_chip_row.dart';
import '../widgets/library/add_playlist_button.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  String selectedFilter = '';

  bool isSearching = false;
  String searchQuery = '';

  List<Map<String, dynamic>> playlists = [
    {'name': 'Top Hits Indonesia', 'isPinned': true},
    {'name': 'Calm Night Mix', 'isPinned': true},
    {'name': 'Daily Mix 1', 'isPinned': true},
    {'name': 'Soft Mix', 'isPinned': false},
    {'name': 'My Playlist #17', 'isPinned': false},
    {'name': 'Discover Weekly', 'isPinned': false},
  ];

  List<Map<String, dynamic>> get sortedPlaylists {
    // Filter playlist berdasarkan pencarian
    List<Map<String, dynamic>> filteredList = playlists.where((item) {
      final name = item['name'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    // urutkan yang Pinned tetap di atas
    filteredList.sort((a, b) {
      if (a['isPinned'] == b['isPinned']) return 0;
      return a['isPinned'] ? -1 : 1;
    });

    return filteredList;
  }

  // Tambah Playlist
  void showCreatePlaylistDialog() {
    final controller = TextEditingController(
      text: 'New Playlist #${playlists.length + 1}',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Give your playlist a name', style: TextStyle(color: Colors.white, fontSize: 18)),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    playlists.add({'name': text, 'isPinned': false});
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Create', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Edit Nama Playlist
  void showEditPlaylistDialog(Map<String, dynamic> item) {
    final controller = TextEditingController(text: item['name']);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Edit playlist name', style: TextStyle(color: Colors.white, fontSize: 18)),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    item['name'] = text;
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Konfirmasi Hapus Playlist
  void showDeletePlaylistDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF282828),
          title: const Text('Delete Playlist?', style: TextStyle(color: Colors.white, fontSize: 18)),
          content: Text(
            'Are you sure want to delete "${item['name']}"?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  playlists.remove(item);
                });
                Navigator.pop(ctx);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Toggle Pin / Unpin
  void togglePin(Map<String, dynamic> item) {
    setState(() {
      item['isPinned'] = !item['isPinned'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayList = sortedPlaylists;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // Menambahkan parameter pencarian ke LibraryHeader] ===
      appBar: LibraryHeader(
        onAddPressed: showCreatePlaylistDialog,
        isSearching: isSearching,
        onSearchToggle: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchQuery = ''; 
            }
          });
        },
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value; 
          });
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterChipRow(
            selectedFilter: selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                selectedFilter = filter;
              });
            },
          ),

          // Tombol Tambah Playlist
          AddPlaylistButton(
            onTap: () {
               showCreatePlaylistDialog();
             },
          ),

          // Daftar Playlist 
          Expanded(
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                return PlaylistItemTile(
                  title: item['name'],
                  isPinned: item['isPinned'],
                  onTogglePin: () => togglePin(item),
                  onEdit: () => showEditPlaylistDialog(item),
                  onDelete: () => showDeletePlaylistDialog(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}