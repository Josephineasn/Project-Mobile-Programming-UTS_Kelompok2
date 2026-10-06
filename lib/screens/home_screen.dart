import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/home/header_greeting.dart';
import '../widgets/home/horizontal_playlist_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Map<String, String>> allPlaylists = [
    {
      'title': 'Daydream Mix',
      'subtitle': 'Lost in thoughts, one track at a time.',
      'imageUrl': 'assets/images/daydream.jpg',
      'category': 'Deep Focus',
    },
    {
      'title': 'Focus Flow',
      'subtitle': 'Zero distractions, pure productivity.',
      'imageUrl': 'assets/images/focus.jpg',
      'category': 'Deep Focus',
    },
    {
      'title': 'Deep Zone',
      'subtitle': 'Ambient soundscapes to lock you in.',
      'imageUrl': 'assets/images/deepzone.jpg',
      'category': 'Deep Focus',
    },
    {
      'title': 'Night Drift',
      'subtitle': 'Empty streets and midnight thoughts.',
      'imageUrl': 'assets/images/nightdrift.jpg',
      'category': 'Midnight Walk',
    },
    {
      'title': 'Starlight',
      'subtitle': 'Soundtrack for your late-night strolls.',
      'imageUrl': 'assets/images/starlight.jpg',
      'category': 'Midnight Walk',
    },
    {
      'title': 'After Hours',
      'subtitle': 'Neon lights and quiet beats.',
      'imageUrl': 'assets/images/afterhours.jpg',
      'category': 'Midnight Walk',
    },
    {
      'title': 'Power Rush',
      'subtitle': 'High energy to crush your limits.',
      'imageUrl': 'assets/images/powerrush.jpg',
      'category': 'Workout Boost',
    },
    {
      'title': 'Beast Mode',
      'subtitle': 'Heavy bass to fuel the grind.',
      'imageUrl': 'assets/images/beastmode.jpg',
      'category': 'Workout Boost',
    },
    {
      'title': 'Hype Mix',
      'subtitle': 'Upbeat tracks for maximum drive.',
      'imageUrl': 'assets/images/hypemix.jpg',
      'category': 'Workout Boost',
    },
    {
      'title': 'Blue Hour',
      'subtitle': 'Soft melodies for heavy feelings.',
      'imageUrl': 'assets/images/bluehour.jpg',
      'category': 'Melancholy',
    },
    {
      'title': 'Soft Fade',
      'subtitle': 'Gentle notes for quiet heartbreak.',
      'imageUrl': 'assets/images/softfade.jpg',
      'category': 'Melancholy',
    },
    {
      'title': 'Melancholy',
      'subtitle': 'Raw, honest songs that understand.',
      'imageUrl': 'assets/images/melancholy.jpg',
      'category': 'Melancholy',
    },
    {
      'title': 'Trending Now',
      'subtitle': 'What the world is listening to today.',
      'imageUrl': 'assets/images/trending.jpg',
      'category': 'Trending Spotlight',
    },
    {
      'title': 'Top Hits Indonesia',
      'subtitle': 'Lagu terpopuler minggu ini.',
      'imageUrl': 'assets/images/tophits.jpg',
      'category': 'Trending Spotlight',
    },
    {
      'title': 'Chart Climbers',
      'subtitle': 'The biggest tracks blowing up right now.',
      'imageUrl': 'assets/images/chart.jpg',
      'category': 'Trending Spotlight',
    },
    {
      'title': 'Hot Right Now',
      'subtitle': 'Viral anthems you cannot skip.',
      'imageUrl': 'assets/images/hotright.jpg',
      'category': 'Trending Spotlight',
    },
  ];

  static const List<Map<String, String>> recentlyPlayed = [
    {
      'title': 'Viva La Vida',
      'subtitle': 'Coldplay',
      'imageUrl': 'assets/images/vivalavida.jpg',
    },
    {
      'title': 'Starboy',
      'subtitle': 'The Weeknd',
      'imageUrl': 'assets/images/starboy.jpg',
    },
    {
      'title': 'Bohemian Rhapsody',
      'subtitle': 'Queen',
      'imageUrl': 'assets/images/bohemian.jpg',
    },
    {
      'title': 'Monokrom',
      'subtitle': 'Tulus',
      'imageUrl': 'assets/images/monokrom.jpg',
    },
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeMoodIndex = 0;

  final List<Map<String, dynamic>> _moodList = [
    {'label': 'All', 'icon': Icons.grid_view_rounded, 'color': AppColors.primaryGreen},
    {'label': 'Deep Focus', 'icon': Icons.bolt_rounded, 'color': const Color.fromARGB(255, 235, 186, 255)},
    {'label': 'Midnight Walk', 'icon': Icons.nightlight_round, 'color': const Color(0xFF579FF4)},
    {'label': 'Workout Boost', 'icon': Icons.local_fire_department_rounded, 'color': Colors.amber},
    {'label': 'Melancholy', 'icon': Icons.cloudy_snowing, 'color': const Color(0xFFC084FC)},
    {'label': 'Trending Spotlight', 'icon': Icons.auto_awesome_rounded, 'color': const Color(0xFFE8FD52)},
  ];

  List<Map<String, String>> get _currentCategoryItems {
    final currentLabel = _moodList[_activeMoodIndex]['label'] as String;
    if (currentLabel == 'All') {
      return HomeScreen.allPlaylists;
    }
    return HomeScreen.allPlaylists
        .where((item) => item['category'] == currentLabel)
        .toList();
  }

  // bento grid atas
  List<Map<String, String>> get _spotlightItems {
    final currentLabel = _moodList[_activeMoodIndex]['label'] as String;
    if (currentLabel == 'All') {
      return [
        HomeScreen.allPlaylists[13],
        HomeScreen.allPlaylists[1],
        HomeScreen.allPlaylists[7],
      ];
    }
    return _currentCategoryItems;
  }

  void _openPlaylistGridScreen(BuildContext context, String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl = item['imageUrl'] ?? '';
                final isAsset = imageUrl.startsWith('assets/');
                final subtitleText = item['subtitle'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: isAsset
                            ? Image.asset(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.music_note, color: Colors.white54),
                                ),
                              )
                            : Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.music_note, color: Colors.white54),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (subtitleText.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeMood = _moodList[_activeMoodIndex];
    final activeColor = activeMood['color'] as Color;
    final activeTitle = activeMood['label'] as String;

    final selectedItems = _currentCategoryItems;
    final spotlightItems = _spotlightItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderGreetingWidget(salam: 'Melodix'),
              const SizedBox(height: 14),

              // Mood & Category
              _buildMoodCapsules(isDark),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activeTitle == 'All' ? 'Spotlight Picks' : activeTitle,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _openPlaylistGridScreen(
                        context,
                        activeTitle == 'All' ? 'All Playlists' : activeTitle,
                        selectedItems,
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildBentoShowcase(isDark, activeColor, spotlightItems),
              const SizedBox(height: 28),

              // Recently Played
              HorizontalPlaylistSection(
                title: 'Recently played',
                items: HomeScreen.recentlyPlayed,
                onSeeAll: () => _openPlaylistGridScreen(
                  context,
                  'Recently played',
                  HomeScreen.recentlyPlayed,
                ),
              ),
              const SizedBox(height: 24),

              // Made For You
              HorizontalPlaylistSection(
                title: activeTitle == 'All'
                    ? 'Made for you'
                    : 'Made for you • $activeTitle',
                items: selectedItems,
                onSeeAll: () => _openPlaylistGridScreen(
                  context,
                  activeTitle == 'All' ? 'Made for you' : 'Made for you ($activeTitle)',
                  selectedItems,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Filter
  Widget _buildMoodCapsules(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _moodList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final mood = _moodList[index];
          final isSelected = _activeMoodIndex == index;
          final accent = mood['color'] as Color;

          return GestureDetector(
            onTap: () => setState(() => _activeMoodIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? accent.withAlpha(45)
                    : (isDark ? const Color(0xFF191B22) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? accent : (isDark ? Colors.white12 : Colors.black12),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    mood['icon'] as IconData,
                    size: 16,
                    color: isSelected ? accent : (isDark ? Colors.white60 : Colors.black54),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    mood['label'] as String,
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Spotlight Showcase
  Widget _buildBentoShowcase(
    bool isDark,
    Color activeAccentColor,
    List<Map<String, String>> items,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    final heroItem = items[0];
    final subItem1 = items.length > 1 ? items[1] : heroItem;
    final subItem2 = items.length > 2 ? items[2] : subItem1;

    final heroImage = heroItem['imageUrl'] ?? '';
    final isHeroAsset = heroImage.startsWith('assets/');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 220,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [
                      activeAccentColor.withAlpha(220),
                      const Color(0xFF11141B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeAccentColor.withAlpha(45),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -25,
                      bottom: -25,
                      child: Opacity(
                        opacity: 0.35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: isHeroAsset
                              ? Image.asset(heroImage, width: 160, height: 160, fit: BoxFit.cover)
                              : Image.network(heroImage, width: 160, height: 160, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              heroItem['category'] ?? 'SPOTLIGHT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                heroItem['title'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: _buildBentoMiniCard(subItem1, isDark, const Color(0xFF1E2838)),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildBentoMiniCard(subItem2, isDark, const Color(0xFF242031)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoMiniCard(Map<String, String> item, bool isDark, Color baseDarkColor) {
    final img = item['imageUrl'] ?? '';
    final isAsset = img.startsWith('assets/');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? baseDarkColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isAsset
                ? Image.asset(img, width: 58, height: 58, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 58, height: 58, color: Colors.grey.shade800, child: const Icon(Icons.music_note, color: Colors.white54)))
                : Image.network(img, width: 58, height: 58, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 58, height: 58, color: Colors.grey.shade800, child: const Icon(Icons.music_note, color: Colors.white54))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item['category'] ?? 'Playlist',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['title'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black12,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}