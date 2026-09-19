import 'package:flutter/material.dart';

class YourLibraryScreen extends StatelessWidget {
  const YourLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam pekat
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
          // Ikon Kaca Pembesar (Search)
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
            },
          ),
          // Ikon Plus (Tambah Playlist)
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
            },
          ),
          // Ikon Gear (Pengaturan) - Tetap dipertahankan di pojok
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
            },
          ),
          const SizedBox(width: 8), 
        ],
      ),
      body: const SizedBox.shrink(), 
    );
  }
}