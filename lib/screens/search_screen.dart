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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //kepala search screen
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green[200],
                    child: const Text(
                      'H',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24,),
                ],
              ),
              const SizedBox(height: 12),

              const CustomSearchBar(),

              const SizedBox(height: 24),

              //untuk widgets category
              // <code>
              // <code>
            ],
          ),
        ),
      ),
    );
  }
}
