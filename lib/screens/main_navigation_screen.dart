import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/audio_controller.dart';
import '../services/song_service.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'player_screen.dart';
import 'premium_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainNavScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _currentIndex;
  final AudioController _audioController = AudioController.instance;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    YourLibraryScreen(),
    PlayerScreen(),
    PremiumScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
    _currentIndex = widget.initialIndex;
    _loadInitialSongs();
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialSongs() async {
    if (_audioController.playlist.isEmpty) {
      try {
        final songs = await SongService.fetchDeezerSongs();
        if (songs.isNotEmpty) {
          // autoPlay: false agar tidak langsung memutar lagu saat aplikasi baru dibuka
          await _audioController.setPlaylist(songs, initialIndex: 0, autoPlay: false);
          // Load lagu & posisi durasi terakhir yang tersimpan di HP
          await _audioController.loadLastPlayedState();
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final currentSong = _audioController.currentSong;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentIndex != 3 && currentSong != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: currentSong.albumCover.isNotEmpty
                          ? Image.network(
                              currentSong.albumCover,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 42,
                              height: 42,
                              color: AppColors.primaryGreen,
                              child: const Icon(Icons.music_note, color: Colors.black),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSong.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: contentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.grey : Colors.grey.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tombol Previous
                    IconButton(
                      icon: Icon(
                        Icons.skip_previous,
                        color: contentColor,
                        size: 22,
                      ),
                      onPressed: () => _audioController.playPrevious(),
                    ),

                    // Tombol Play / Pause
                    IconButton(
                      icon: Icon(
                        _audioController.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: contentColor,
                        size: 24,
                      ),
                      onPressed: () => _audioController.togglePlayPause(),
                    ),

                    // Tombol Next
                    IconButton(
                      icon: Icon(
                        Icons.skip_next,
                        color: contentColor,
                        size: 22,
                      ),
                      onPressed: () => _audioController.playNext(),
                    ),
                  ],
                ),
              ),
            ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
            selectedItemColor: AppColors.primaryGreen,
            unselectedItemColor: isDark ? Colors.grey : Colors.black45,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Your Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_fill),
                label: 'Player',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium),
                label: 'Premium',
              ),
            ],
          ),
        ],
      ),
    );
  }
}