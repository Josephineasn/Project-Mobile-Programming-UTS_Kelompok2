import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/audio_controller.dart';
import '../services/song_service.dart';
import '../widgets/player/mini_player_bar.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
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
  late Future<void> _initFuture;

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    YourLibraryScreen(),
    PremiumScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
    _currentIndex = widget.initialIndex;
    _initFuture = _loadInitialSongs();
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
    try {
      await _audioController.loadLikedSongs();
      await _audioController.loadLastPlayedState();

      if (_audioController.playlist.isEmpty) {
        final songs = await SongService.fetchDeezerSongs();
        if (songs.isNotEmpty) {
          await _audioController.setPlaylist(songs, initialIndex: 0, autoPlay: false);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_audioController.hasPlayedBefore) {
          return Scaffold(
            backgroundColor: isDark ? AppColors.background : Theme.of(context).scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
          );
        }

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : Theme.of(context).scaffoldBackgroundColor,
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MiniPlayerBar(),
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
                    icon: Icon(Icons.workspace_premium),
                    label: 'Premium',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}