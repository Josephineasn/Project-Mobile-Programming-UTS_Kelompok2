import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/home/header_greeting.dart';
import '../widgets/home/category_filter.dart';
import '../widgets/home/playlist_card.dart';
import '../widgets/home/horizontal_playlist_section.dart';

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


  static const List<Map<String, String>> recentlyPlayed = [
    {
      'title': 'Viva La Vida',
      'subtitle': 'Coldplay',
      'imageUrl': 'https://picsum.photos/seed/coldplay/250',
    },
    {
      'title': 'Starboy',
      'subtitle': 'The Weeknd',
      'imageUrl': 'https://picsum.photos/seed/weeknd/250',
    },
    {
      'title': 'Bohemian Rhapsody',
      'subtitle': 'Queen',
      'imageUrl': 'https://picsum.photos/seed/queen/250',
    },
    {
      'title': 'Monokrom',
      'subtitle': 'Tulus',
      'imageUrl': 'https://picsum.photos/seed/tulus/250',
    },
  ];

  static const List<Map<String, String>> madeForYou = [
    {
      'title': 'Your All-Time Top SOngs',
      'subtitle': 'Hindia, Nadin Amizah, Bernadya',
      'imageUrl': 'https://picsum.photos/seed/dailymix/250',
    },
    {
      'title': 'Hopeless Romantic Love Mix',
      'subtitle': 'Hopeless Romantic Love music for you. Also try soft pop,easy listening,indie,bollywood,singer-songwriter',
      'imageUrl': 'assets/images/hopeless-romantic.jpg',
    },
    {
      'title': 'Yearning Mix',
      'subtitle': 'Yearning music for  you. Also try soft pop,indie,alternative,singeer-songwriter,harana',
      'imageUrl': 'assets/images/yearning.jpg',
    },
    {
      'title': 'Delulu Mix',
      'subtitle': 'Delulu music for you. Also try opm,harana,kundiman,bollywood,pinoy indie',
      'imageUrl': 'assets/images/delulu.jpg',
    },
    {
      'title': 'Gentle Love Mix',
      'subtitle': 'Gentle Love music for you. Also try singer-songwriter, indie pop,italo disco,easy listening,new wave',
      'imageUrl': 'assets/images/gentle-love.jpg',
    },
    {
      'title': 'Situationship Mix',
      'subtitle': 'Situationship for you. Also try pop, singer-songwriter,slowcore,indie,alternative',
      'imageUrl': 'assets/images/situationship.jpg',
    },
    {
      'title': 'Crying Sad Mix',
      'subtitle': 'Crying Sad Music for you. Also try pop,slowcore,indie,singer-songwriter,latin',
      'imageUrl': 'assets/images/crying-sad.jpg',
    },
    {
      'title': 'Moody Sad Mix',
      'subtitle': 'Moody Sad music for you.Also try pop,slowcore,easy listening,singer-songwriter,latin',
      'imageUrl': 'assets/images/moody-sad.jpg',
    },
    {
      'title': 'Masterpiece Mix',
      'subtitle': 'Masterpiece music for you.Also try hindi pop,bollywood,indian indie,indorock,indonesian rock',
      'imageUrl': 'assets/images/masterpiece.jpg',
    },
    {
      'title': 'Comforting Mix',
      'subtitle': 'Comforting music for you. Also try slowcore,indie,soft pop,singer-songwriter,harana',
      'imageUrl': 'assets/images/comforting.jpg',
    },
    {
      'title': 'Fomo Mix',
      'subtitle': 'Fomo music for you.Also try indie,pop,indorock,alternative,indonesian jazz',
      'imageUrl': 'assets/images/fomo.jpg',
    },
    {
      'title': 'Main Character Mix',
      'subtitle': 'Main Character music for you.Also try pop,tollywood,alternative,indie,dance',
      'imageUrl': 'assets/images/main-character.jpg',
    },
    {
      'title': 'Rizz Mix',
      'subtitle': 'Rizz music for you.Also try r&b,childrens music,disco,bisrock,hyperpop',
      'imageUrl': 'assets/images/rizz.jpg',
    },
  ];

@override
    Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              const SizedBox(height: 24,),

              const HorizontalPlaylistSection(
                title: 'Recently played',
                items: recentlyPlayed,
              ),
              const SizedBox(height: 24),

              // Bagian Horizontal 2: Made For You
              const HorizontalPlaylistSection(
                title: 'Made for you',
                items: madeForYou,
              ),
              const SizedBox(height: 100), 
            ],
            ),
          ),
        )
    );
    }
}