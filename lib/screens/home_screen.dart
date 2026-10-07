import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/song_model.dart';
import '../services/audio_controller.dart';
import '../services/playlist_controller.dart';
import '../services/song_service.dart';
import '../widgets/home/header_greeting.dart';
import '../widgets/home/horizontal_playlist_section.dart';
import 'playlist_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Map<String, String>> allPlaylists = [
    {'title': 'Daydream Mix', 'subtitle': 'Lost in thoughts.', 'imageUrl': 'assets/images/daydream.jpg', 'category': 'Deep Focus'},
    {'title': 'Focus Flow', 'subtitle': 'Zero distractions.', 'imageUrl': 'assets/images/focus.jpg', 'category': 'Deep Focus'},
    {'title': 'Deep Zone', 'subtitle': 'Ambient soundscapes.', 'imageUrl': 'assets/images/deepzone.jpg', 'category': 'Deep Focus'},
    {'title': 'Night Drift', 'subtitle': 'Midnight thoughts.', 'imageUrl': 'assets/images/nightdrift.jpg', 'category': 'Midnight Walk'},
    {'title': 'Starlight', 'subtitle': 'Late-night strolls.', 'imageUrl': 'assets/images/starlight.jpg', 'category': 'Midnight Walk'},
    {'title': 'After Hours', 'subtitle': 'Neon lights.', 'imageUrl': 'assets/images/afterhours.jpg', 'category': 'Midnight Walk'},
    {'title': 'Power Rush', 'subtitle': 'High energy.', 'imageUrl': 'assets/images/powerrush.jpg', 'category': 'Workout Boost'},
    {'title': 'Beast Mode', 'subtitle': 'Heavy bass.', 'imageUrl': 'assets/images/beastmode.jpg', 'category': 'Workout Boost'},
    {'title': 'Hype Mix', 'subtitle': 'Upbeat tracks.', 'imageUrl': 'assets/images/hypemix.jpg', 'category': 'Workout Boost'},
    {'title': 'Blue Hour', 'subtitle': 'Soft melodies.', 'imageUrl': 'assets/images/bluehour.jpg', 'category': 'Melancholy'},
    {'title': 'Soft Fade', 'subtitle': 'Gentle notes.', 'imageUrl': 'assets/images/softfade.jpg', 'category': 'Melancholy'},
    {'title': 'Melancholy', 'subtitle': 'Raw honest songs.', 'imageUrl': 'assets/images/melancholy.jpg', 'category': 'Melancholy'},
    {'title': 'Trending Now', 'subtitle': 'Popular today.', 'imageUrl': 'assets/images/trending.jpg', 'category': 'Trending Spotlight'},
    {'title': 'Top Hits Indonesia','subtitle': 'Lagu terpopuler minggu ini.','imageUrl': 'assets/images/tophits.jpg','category': 'Trending Spotlight'},
    {'title': 'Chart Climbers', 'subtitle': 'Blowing up right now.', 'imageUrl': 'assets/images/chart.jpg', 'category': 'Trending Spotlight'},
    {'title': 'Hot Right Now', 'subtitle': 'Viral anthems.', 'imageUrl': 'assets/images/hotright.jpg', 'category': 'Trending Spotlight'},
  ];

  static const List<Map<String, String>> recentlyPlayed = [
    {'title': 'Viva La Vida', 'subtitle': 'Coldplay', 'imageUrl': 'assets/images/vivalavida.jpg'},
    {'title': 'Starboy', 'subtitle': 'The Weeknd', 'imageUrl': 'assets/images/starboy.jpg'},
    {'title': 'Bohemian Rhapsody', 'subtitle': 'Queen', 'imageUrl': 'assets/images/bohemian.jpg'},
    {'title': 'Monokrom', 'subtitle': 'Tulus', 'imageUrl': 'assets/images/monokrom.jpg'},
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeMoodIndex = 0;
  final AudioController _audio = AudioController.instance;
  String _activeTitle = '';

  final List<Map<String, dynamic>> _moodList = [
    {'label': 'All', 'icon': Icons.grid_view_rounded, 'color': AppColors.primaryGreen},
    {'label': 'Deep Focus', 'icon': Icons.bolt_rounded, 'color': const Color.fromARGB(255, 235, 186, 255)},
    {'label': 'Midnight Walk', 'icon': Icons.nightlight_round, 'color': const Color(0xFF579FF4)},
    {'label': 'Workout Boost', 'icon': Icons.local_fire_department_rounded, 'color': Colors.amber},
    {'label': 'Melancholy', 'icon': Icons.cloudy_snowing, 'color': const Color(0xFFC084FC)},
    {'label': 'Trending Spotlight', 'icon': Icons.auto_awesome_rounded, 'color': const Color(0xFFE8FD52)},
  ];

  @override
  void initState() {
    super.initState();
    _audio.addListener(_refresh);
  }

  @override
  void dispose() {
    _audio.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  List<Map<String, String>> get _currentCategoryItems {
    final label = _moodList[_activeMoodIndex]['label'] as String;
    if (label == 'All') return HomeScreen.allPlaylists;
    return HomeScreen.allPlaylists.where((p) => p['category'] == label).toList();
  }

  List<Map<String, String>> get _spotlightItems {
    if (_moodList[_activeMoodIndex]['label'] == 'All') {
      return [HomeScreen.allPlaylists[13], HomeScreen.allPlaylists[1], HomeScreen.allPlaylists[7]];
    }
    return _currentCategoryItems;
  }

  Widget _buildImageWidget(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => Container(width: width, height: height, color: Colors.grey.shade800, child: const Icon(Icons.music_note, color: Colors.white54)),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, _, _) => Container(width: width, height: height, color: Colors.grey.shade800, child: const Icon(Icons.music_note, color: Colors.white54)),
    );
  }

  void _quickPlay(Map<String, String> item) async {
    final title = (item['title'] ?? '').toLowerCase();
    final currentTitle = (_audio.currentSong?.title ?? '').toLowerCase();

    if (_audio.isPlaying && (currentTitle == title || _activeTitle.toLowerCase() == title)) {
      await _audio.togglePlayPause();
      setState(() {});
      return;
    }

    if (!_audio.isPlaying && _audio.currentSong != null && _activeTitle.toLowerCase() == title) {
      await _audio.togglePlayPause();
      setState(() {});
      return;
    }

    _activeTitle = item['title'] ?? '';

    final found = PlaylistController.instance.userPlaylists.firstWhere(
      (p) => (p['name'] ?? '').toLowerCase() == title,
      orElse: () => {},
    );

    List<SongModel> songs = List<SongModel>.from(found['songs'] ?? []);

    if (songs.isNotEmpty) {
      await _audio.setPlaylist(songs, initialIndex: 0, autoPlay: true, playlistName: item['title'] ?? '');
    } else {
      try {
        final deezer = await SongService.fetchDeezerSongs();
        if (deezer.isNotEmpty) {
          final idx = deezer.indexWhere((s) => s.title.toLowerCase().contains(title));
          if (idx != -1) {
            await _audio.setPlaylist([deezer[idx]], initialIndex: 0, autoPlay: true, playlistName: item['title'] ?? '');
            setState(() {});
            return;
          }
        }
      } catch (e) {
        debugPrint('Error: $e');
      }

      await _audio.setPlaylist([
        SongModel(title: item['title'] ?? '', artist: item['subtitle'] ?? 'Various Artists', audioUrl: '', albumCover: item['imageUrl'] ?? '')
      ], initialIndex: 0, autoPlay: true, playlistName: item['title'] ?? '');
    }
    setState(() {});
  }

  void _openDetail(Map<String, String> item) {
    final title = item['title'] ?? 'Playlist';
    final found = PlaylistController.instance.userPlaylists.firstWhere(
      (p) => p['name'] == title,
      orElse: () => {'name': title, 'imageUrl': item['imageUrl'] ?? '', 'songs': []},
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistDetailScreen(playlist: found)));
  }

  void _openGrid(String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Scaffold(
            backgroundColor: isDark ? const Color(0xFF121316) : const Color(0xFFEBEFF2),
            appBar: AppBar(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.74,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isPlaying = _audio.isPlaying &&
                    ((_audio.currentSong?.title ?? '').toLowerCase() == (item['title'] ?? '').toLowerCase() ||
                        _activeTitle.toLowerCase() == (item['title'] ?? '').toLowerCase());

                return GestureDetector(
                  onTap: () => _openDetail(item),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? const [Color(0xFF282B34), Color(0xFF1A1C23)]
                            : const [Color(0xFFF2F5F8), Color(0xFFE4E8ED)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white.withValues(alpha: 0.7),
                        width: 1.2,
                      ),
                      boxShadow: isDark
                          ? [
                              BoxShadow(color: Colors.white.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(-3, -3)),
                              BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 12, offset: const Offset(4, 6)),
                            ]
                          : [
                              const BoxShadow(color: Colors.white, blurRadius: 10, offset: Offset(-5, -5)),
                              BoxShadow(color: const Color(0xFFA6B4C4).withValues(alpha: 0.55), blurRadius: 10, offset: const Offset(5, 5)),
                            ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: _buildImageWidget(item['imageUrl'] ?? ''),
                                ),
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: GestureDetector(
                                  onTap: () => _quickPlay(item),
                                  child: _playButton(isPlaying, 32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(item['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF2D3748), fontWeight: FontWeight.bold, fontSize: 13.5)),
                        if ((item['subtitle'] ?? '').isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(item['subtitle'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.white60 : const Color(0xFF718096), fontSize: 11.5, fontWeight: FontWeight.w500)),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _playButton(bool isPlaying, double size) {
    if (isPlaying) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: size * 0.15, height: size * 0.50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(size * 0.1))),
              SizedBox(width: size * 0.15),
              Container(width: size * 0.15, height: size * 0.50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(size * 0.1))),
            ],
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))]),
      child: Icon(Icons.play_arrow_rounded, color: Colors.black, size: size * 0.65),
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
              ValueListenableBuilder<UserAccountData>(
                valueListenable: currentAccountNotifier,
                builder: (context, account, _) {
                  final greetingText = account.isLoggedIn ? 'Hi, ${account.name}' : 'Melodix';
                  return HeaderGreetingWidget(salam: greetingText);
                },
              ),
              const SizedBox(height: 14),
              // Filter kategori atas
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _moodList.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final mood = _moodList[index];
                    final isSelected = _activeMoodIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _activeMoodIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? (mood['color'] as Color).withValues(alpha: 0.18) : (isDark ? const Color(0xFF191B22) : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isSelected ? (mood['color'] as Color) : (isDark ? Colors.white12 : Colors.black12)),
                        ),
                        child: Row(
                          children: [
                            Icon(mood['icon'] as IconData, size: 16, color: isSelected ? (mood['color'] as Color) : (isDark ? Colors.white60 : Colors.black54)),
                            const SizedBox(width: 7),
                            Text(mood['label'] as String, style: TextStyle(color: isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.white70 : Colors.black87), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activeTitle == 'All' ? 'Spotlight Picks' : activeTitle, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 19, fontWeight: FontWeight.w800)),
                    GestureDetector(
                      onTap: () => _openGrid(activeTitle == 'All' ? 'All Playlists' : activeTitle, selectedItems),
                      child: Text('See All', style: TextStyle(color: activeColor, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Bento Spotlight
              if (spotlightItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 220,
                    child: Row(
                      children: [
                        // Kartu spotlight besar kiri
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () => _openDetail(spotlightItems[0]),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: LinearGradient(
                                  colors: [activeColor.withValues(alpha: 0.86), const Color(0xFF11141B)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [BoxShadow(color: activeColor.withValues(alpha: 0.18), blurRadius: 16, offset: const Offset(0, 6))],
                              ),
                              child: Stack(
                                children: [
                                  // Foto latar belakang kartu spotlight
                                  Positioned(
                                    right: -25,
                                    bottom: -25,
                                    child: Opacity(
                                      opacity: 0.45,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: _buildImageWidget(spotlightItems[0]['imageUrl'] ?? '', width: 170, height: 170),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                                          child: Text(spotlightItems[0]['category'] ?? 'SPOTLIGHT', style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold)),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(spotlightItems[0]['title'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 10),
                                            GestureDetector(
                                              onTap: () => _quickPlay(spotlightItems[0]),
                                              child: _playButton(_audio.isPlaying && _activeTitle == spotlightItems[0]['title'], 36),
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
                        ),
                        const SizedBox(width: 12),
                        // Dua kartu kecil kanan
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              for (int i = 1; i <= 2 && i < spotlightItems.length; i++)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _openDetail(spotlightItems[i]),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: i == 1 ? 10 : 0),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark ? (i == 1 ? const Color(0xFF1E2838) : const Color(0xFF242031)) : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: _buildImageWidget(spotlightItems[i]['imageUrl'] ?? '', width: 58, height: 58),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(spotlightItems[i]['category'] ?? 'Playlist', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 10)),
                                                Text(spotlightItems[i]['title'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => _quickPlay(spotlightItems[i]),
                                            child: _playButton(_audio.isPlaying && _activeTitle == spotlightItems[i]['title'], 28),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              // Recently Played
              HorizontalPlaylistSection(
                title: 'Recently played',
                items: HomeScreen.recentlyPlayed,
                onSeeAll: () => _openGrid('Recently played', HomeScreen.recentlyPlayed),
                onItemTap: _openDetail,
                onPlayTap: _quickPlay,
                activePlayingTitle: _activeTitle,
              ),
              const SizedBox(height: 24),
              // Made For You
              HorizontalPlaylistSection(
                title: activeTitle == 'All' ? 'Made for you' : 'Made for you • $activeTitle',
                items: selectedItems,
                onSeeAll: () => _openGrid(activeTitle == 'All' ? 'Made for you' : 'Made for you ($activeTitle)', selectedItems),
                onItemTap: _openDetail,
                onPlayTap: _quickPlay,
                activePlayingTitle: _activeTitle,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
