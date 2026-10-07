import 'package:flutter/material.dart';
import '../../models/song_model.dart';
import '../../services/audio_controller.dart';

class QueueActionButton extends StatelessWidget {
  final SongModel song;
  final double size;
  final Color? color;

  const QueueActionButton({
    super.key,
    required this.song,
    this.size = 26,
    this.color,
  });

  void _handleTap(BuildContext context) {
    final audioController = AudioController.instance;

    if (audioController.isCurrentlyPlayingSong(song)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Already playing "${song.title}"'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (audioController.isInQueue(song)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Already in queue: "${song.title}"'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    audioController.addToQueue(song);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${song.title}" to queue'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: audioController,
      builder: (context, _) {
        final isCurrent = audioController.isCurrentlyPlayingSong(song);
        final isQueued = audioController.isInQueue(song);

        final icon = Icons.queue_music;
        final iconColor = isCurrent
            ? (color ?? (isDark ? Colors.white38 : Colors.black38))
            : isQueued
                ? const Color(0xFF1DB954)
                : (color ?? (isDark ? Colors.white : Colors.black87));

        return IconButton(
          tooltip: isCurrent
              ? 'Already playing'
              : isQueued
                  ? 'Already in queue'
                  : 'Add to Queue',
          icon: Icon(icon, color: iconColor, size: size),
          onPressed: () => _handleTap(context),
        );
      },
    );
  }
}
