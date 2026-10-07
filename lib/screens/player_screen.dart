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

    final isQueuePlayback = _audioController.isQueuePlayback;
    final sourceName = _audioController.currentPlaylistName.trim();

    final sourceLabel = isQueuePlayback
        ? 'FROM QUEUE'
        : sourceName.isNotEmpty
            ? 'FROM $sourceName'
            : 'FROM HOME';

    final sourceTitle = currentSong.title;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sourceLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sourceTitle,
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
            const SizedBox(height: 24),
            const _QueueSection(),
          ],
        ),
      ),
    );
  }
}

class _QueueSection extends StatelessWidget {
  const _QueueSection();

  Future<void> _confirmClearQueue(BuildContext context) async {
    final controller = AudioController.instance;
    if (controller.queue.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF282828) : Colors.white,
        title: Text(
          'Clear Queue?',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Text(
          'Remove all songs from your queue?',
          style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Clear',
              style: TextStyle(color: Color(0xFF1DB954)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      controller.clearQueue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AudioController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey : Colors.grey.shade600;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final queue = controller.queue;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'NEXT UP',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: queue.isEmpty
                      ? null
                      : () => _confirmClearQueue(context),
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Color(0xFF1DB954)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (queue.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Queue is empty',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: queue.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final song = queue[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF22252E) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: song.albumCover.isNotEmpty
                              ? Image.network(
                                  song.albumCover,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 48,
                                    height: 48,
                                    color: Colors.grey.shade800,
                                    child: const Icon(Icons.music_note, color: Colors.white54),
                                  ),
                                )
                              : Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.music_note, color: Colors.white54),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                song.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: subTextColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove from Queue',
                          icon: Icon(
                            Icons.delete_outline,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          onPressed: () => controller.removeFromQueue(song),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
