import 'package:flutter/material.dart';
import '../../services/audio_controller.dart';
import '../../screens/player_screen.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;

    return ListenableBuilder(
      listenable: audioController,
      builder: (context, _) {
        final currentSong = audioController.currentSong;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final contentColor = isDark ? Colors.white : Colors.black87;

        if (currentSong == null || !audioController.hasPlayedBefore) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerScreen()),
            );
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
                          color: const Color(0xFF1DB954),
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
                IconButton(
                  icon: Icon(Icons.skip_previous, color: contentColor, size: 22),
                  onPressed: () => audioController.playPrevious(),
                ),
                
                IconButton(
                  icon: Icon(
                    audioController.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: contentColor,
                    size: 24,
                  ),
                  onPressed: () => audioController.togglePlayPause(),
                ),

                IconButton(
                  icon: Icon(Icons.skip_next, color: contentColor, size: 22),
                  onPressed: () => audioController.playNext(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}