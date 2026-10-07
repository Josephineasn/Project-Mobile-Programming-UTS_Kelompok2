import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SongProgressBar extends StatefulWidget {
  final AudioPlayer audioPlayer;

  const SongProgressBar({
    super.key,
    required this.audioPlayer,
  });

  @override
  State<SongProgressBar> createState() => _SongProgressBarState();
}

class _SongProgressBarState extends State<SongProgressBar> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioListeners();
  }

  void _initAudioListeners() {
    widget.audioPlayer.getDuration().then((dur) {
      if (dur != null && mounted) {
        setState(() {
          _duration = dur;
        });
      }
    });

    widget.audioPlayer.onPositionChanged.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });

    widget.audioPlayer.onDurationChanged.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxMs = _duration.inMilliseconds.toDouble();
    final currentMs = _position.inMilliseconds.toDouble();

    final safeMax = maxMs > 0 ? maxMs : 1.0;
    final safeValue = currentMs.clamp(0.0, safeMax);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            activeTrackColor: const Color(0xFF1DB954),
            inactiveTrackColor: isDark ? Colors.white24 : Colors.black12,
            thumbColor: const Color(0xFF1DB954),
          ),
          child: Slider(
            min: 0.0,
            max: safeMax,
            value: safeValue,
            onChanged: (value) async {
              final newPosition = Duration(milliseconds: value.toInt());
              await widget.audioPlayer.seek(newPosition);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}