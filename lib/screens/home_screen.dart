import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/home/header_greeting.dart';
import '../widgets/home/category_filter.dart';
import '../widgets/home/playlist_card.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

  static const List<Map<String, String>> recentPlaylists = [
    {'title': 'Top Hits Indonesia', 'imageUrl': 'https://i.pinimg.com/1200x/5e/73/1a/5e731a8079818156c4ebe3e928c9e173.jpg'},
    {'title': 'Calm Night Mix', 'imageUrl': 'https://i.pinimg.com/1200x/0a/1b/9c/0a1b9c9ba6956f06f7358d9efc9b3949.jpg'},
    {'title': 'Daily Mix 1', 'imageUrl': 'https://i.pinimg.com/736x/fb/4a/67/fb4a67c491ed6c28c0d12eb686f7c395.jpg'},
    {'title': 'Soft Mix', 'imageUrl': 'https://i.pinimg.com/736x/11/4f/e3/114fe33c7abd274985eeb90096a55960.jpg'},
    {'title': 'My Playlist #17', 'imageUrl': 'https://i.pinimg.com/736x/8c/ae/65/8cae65c1e73246ede11231230671b11b.jpg'},
    {'title': 'Discover Weekly', 'imageUrl': 'https://i.pinimg.com/736x/e0/10/d4/e010d45a9468f1265eac61d58dfaec94.jpg'},
  ];

@override
    Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderGreetingWidget(salam: 'Selamat Datang'),
              const SizedBox(height: 8),
              CategoryFilter(
                onSelected: (category) {

                },
              ),
              const SizedBox(height: 16),

              const PlaylistCardGrid(items: recentPlaylists),
              const SizedBox(height: 24,)
            ],
            ),
          ),
        )
    );
    }
}