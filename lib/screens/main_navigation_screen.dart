import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/audio_controller.dart';
import '../services/song_service.dart';
import '../widgets/player/mini_player_bar.dart';
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
        await _audioController.loadLikedSongs();

        final songs = await SongService.fetchDeezerSongs();
        if (songs.isNotEmpty) {
          await _audioController.setPlaylist(songs, initialIndex: 0, autoPlay: false);
          await _audioController.loadLastPlayedState();
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          if (_currentIndex != 3) const MiniPlayerBar(),

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