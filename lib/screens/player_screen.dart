import 'package:flutter/material.dart';
import '../services/audio_controller.dart';
import '../services/song_service.dart';
import '../widgets/player/album_art_view.dart';
import '../widgets/player/song_title_artist.dart';
import '../widgets/player/song_progress_bar.dart';
import '../widgets/player/player_controller_buttons.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioController _audioController = AudioController.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_audioController.currentSong == null) {
        _checkAndLoadSongs();
      }
    });
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _checkAndLoadSongs() async {
    if (_audioController.currentSong == null && _audioController.playlist.isEmpty) {
      setState(() => _isLoading = true);
      try {
        final songs = await SongService.fetchDeezerSongs();
        if (songs.isNotEmpty) {
          await _audioController.setPlaylist(songs, initialIndex: 0, autoPlay: false);
        }
      } catch (_) {
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final currentSong = _audioController.currentSong;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)),
        ),
      );
    }

    if (currentSong == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Now Playing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_off_outlined,
                size: 80,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              const SizedBox(height: 16),
              Text(
                'No Song Playing',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: contentColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a song from Home or Search to play',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _checkAndLoadSongs,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Load Sample Songs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final hasPlaylistName = _audioController.currentPlaylistName.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasPlaylistName ? 'PLAYING FROM PLAYLIST' : 'NOW PLAYING',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hasPlaylistName ? _audioController.currentPlaylistName : currentSong.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            AlbumArtView(
              imageUrl: currentSong.albumCover,
            ),
            const SizedBox(height: 24),

            SongTitleArtist(song: currentSong),
            const SizedBox(height: 16),

            SongProgressBar(audioPlayer: _audioController.player),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: _audioController.isShuffle
                        ? const Color(0xFF1DB954)
                        : (isDark ? Colors.grey : Colors.grey.shade600),
                    size: 24,
                  ),
                  onPressed: () => _audioController.toggleShuffle(),
                ),
                const PlayerControllerButtons(),
                IconButton(
                  icon: Icon(
                    Icons.repeat,
                    color: _audioController.isRepeat
                        ? const Color(0xFF1DB954)
                        : (isDark ? Colors.grey : Colors.grey.shade600),
                    size: 24,
                  ),
                  onPressed: () => _audioController.toggleRepeat(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}