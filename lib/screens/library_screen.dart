import 'package:flutter/material.dart';

class YourLibraryScreen extends StatelessWidget {
  const YourLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background hitam pekat
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Selamat Datang',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Ikon Lonceng (Notifikasi)
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // Aksi saat ikon ditekan
            },
          ),
          // Ikon Gear (Pengaturan)
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