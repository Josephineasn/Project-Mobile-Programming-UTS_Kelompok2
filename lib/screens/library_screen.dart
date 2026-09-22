import 'package:flutter/material.dart';
import '../widgets/library/playlist_item_tile.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam pekat
      
      // HEADER
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Your Library Playlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8), 
        ],
      ),
      
      // BODY (Tombol Filter + Daftar Playlist)
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tombol Filter (Playlists & Artist)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                // Filter Playlists
                ChoiceChip(
                  label: Text(
                    'Playlists',
                    style: TextStyle(
                      color: selectedFilter == 'Playlists' ? Colors.black : Colors.white,
                      fontWeight: selectedFilter == 'Playlists' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: selectedFilter == 'Playlists',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[900],
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = selected ? 'Playlists' : '';
                    });
                  },
                ),
                const SizedBox(width: 12),
                
                // Filter Artist
                ChoiceChip(
                  label: Text(
                    'Artist',
                    style: TextStyle(
                      color: selectedFilter == 'Artist' ? Colors.black : Colors.white,
                      fontWeight: selectedFilter == 'Artist' ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: selectedFilter == 'Artist',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey[900],
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  showCheckmark: false,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedFilter = selected ? 'Artist' : '';
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Daftar Playlist
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Menampilkan 3 item dummy
              itemBuilder: (context, index) {
                return PlaylistItemTile(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}