import 'package:flutter/material.dart';
import '../../screens/premium_screen.dart';
import '../../services/audio_controller.dart';
import '../../services/premium_controller.dart';

class PlayerControllerButtons extends StatelessWidget {
  const PlayerControllerButtons({super.key});

  void _handleSkipNext(BuildContext context, AudioController audioController) async {
    final canSkip = await audioController.playNext(isUserInitiated: true);

    if (!canSkip && context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF1E212B),
          content: const Text(
            'Limit skip habis (Maks 3x untuk Free). Upgrade ke Premium!',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          action: SnackBarAction(
            label: 'PREMIUM',
            textColor: Colors.amber,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;

    return ListenableBuilder(
      listenable: audioController,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = isDark ? Colors.white : Colors.black87;
        final isFreeAndLimited = !PremiumController.isPremium.value && !audioController.canSkip;

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
              icon: Icon(
                Icons.skip_next,
                color: isFreeAndLimited ? Colors.grey.shade600 : iconColor,
                size: 36,
              ),
              onPressed: () => _handleSkipNext(context, audioController),
            ),
          ],
        );
      },
    );
  }
}