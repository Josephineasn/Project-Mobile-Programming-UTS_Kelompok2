import 'package:flutter/material.dart';

import '../widgets/search/custom_search_bar.dart';
import '../widgets/search/search_category.dart';
import '../widgets/search/search_card.dart';

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
                        fontSize: 14,
                      ),
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

                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const CustomSearchBar(),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SearchCategory(title: "Musik", color: Colors.pink),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SearchCategory(title: "Podcast", color: Colors.teal),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SearchCategory(
                      title: "Acara Langsung",
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SearchCategory(
                      title: "K-Pop ON!",
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                "Temukan sesuatu yang lain",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 230,

                child: ListView(
                  scrollDirection: Axis.horizontal,

                  children: [
                    SearchCard(
                      title: "#timor hip hop",
                      image: "assets/images/hiphop.jpg",
                    ),

                    SearchCard(
                      title: "#happy dance",
                      image: "assets/images/dance.jpg",
                    ),

                    SearchCard(
                      title: "Trending Music",
                      image: "assets/images/music.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
