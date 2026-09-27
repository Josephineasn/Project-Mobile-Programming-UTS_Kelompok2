import 'package:flutter/material.dart';

class SongProgressBar extends StatefulWidget {
  const SongProgressBar({super.key});

  @override
  State<SongProgressBar> createState() => _SongProgressBarState();
}

class _SongProgressBarState extends State<SongProgressBar> {
  double _currentSliderValue = 0.3; 

  String _formatDuration(double value) {
    int totalSeconds = (value * 215).toInt(); 
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
          ),
          child: Slider(
            value: _currentSliderValue,
            activeColor: Colors.green,
            inactiveColor: Colors.grey[800],
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentSliderValue),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Text(
                '3:35',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}