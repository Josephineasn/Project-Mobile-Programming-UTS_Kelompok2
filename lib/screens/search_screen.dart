import 'package:flutter/material.dart';

import '../widgets/custom_search_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //kepala search screen
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple[200],
                    child: const Text(
                      'H',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Cari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.camera_alt_outlined, color: Colors.white),
                ],
              ),
              const SizedBox(height: 24),

              const CustomSearchBar(),

              const SizedBox(height: 24),

              //untuk widgets category
              // <code>
              // <code>
            ],
          ),
        ),
      ),
      // menu bawah
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Koleksi Kamu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium),
            label: 'Premium',
          ),
        ],
      ),
    );
  }
}
