import 'package:flutter/material.dart';
import '../../services/audio_controller.dart';

class PlayerControllerButtons extends StatelessWidget {
  const PlayerControllerButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;

    return ListenableBuilder(
      listenable: audioController,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black87;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous, color: iconColor, size: 36),
              onPressed: () => audioController.playPrevious(),
            ),
            const SizedBox(width: 24),
            GestureDetector(
              onTap: () => audioController.togglePlayPause(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1DB954),
                ),
                child: Icon(
                  audioController.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: Icon(Icons.skip_next, color: iconColor, size: 36),
              onPressed: () => audioController.playNext(),
            ),
          ],
        );
      },
    );
  }
}