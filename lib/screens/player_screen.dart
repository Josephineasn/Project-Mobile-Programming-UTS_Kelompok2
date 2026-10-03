import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../services/audio_controller.dart';
import '../widgets/player/album_art_view.dart';
import '../widgets/player/song_progress_bar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioController _audioController = AudioController.instance;
  
  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;
    final currentSong = _audioController.currentSong;

    if (currentSong == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    final isLiked = _audioController.isLiked(currentSong);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            AlbumArtView(
              height: 260.0,
              imageUrl: currentSong.albumCover,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSong.artist,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.green : contentColor,
                  ),
                  onPressed: () {
                    _audioController.toggleLike(currentSong);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SongProgressBar(audioPlayer: _audioController.player),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: contentColor, size: 36),
                  onPressed: () => _audioController.playPrevious(),
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(
                    _audioController.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: contentColor,
                  ),
                  onPressed: () => _audioController.togglePlayPause(),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: contentColor, size: 36),
                  onPressed: () => _audioController.playNext(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}