import 'package:flutter/material.dart';
import '../services/audio_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  void _showClearConfirmDialog(BuildContext context, AudioController audioController) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear History?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'All recently played history will be removed.',
          style: TextStyle(color: Colors.white70, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              audioController.clearAllHistory();
              Navigator.pop(ctx);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade800,
        child: const Icon(Icons.music_note, color: Colors.white),
      );
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 48,
          height: 48,
          color: Colors.grey.shade800,
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
      );
    }

    return Image.asset(
      path,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        width: 48,
        height: 48,
        color: Colors.grey.shade800,
        child: const Icon(Icons.music_note, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Played'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ListenableBuilder(
            listenable: audioController,
            builder: (context, _) {
              if (audioController.recentlyPlayedHistory.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () => _showClearConfirmDialog(context, audioController),
                child: const Text(
                  'Clear all',
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: audioController,
        builder: (context, _) {
          final history = audioController.recentlyPlayedHistory;

          if (history.isEmpty) {
            return Center(
              child: Text(
                'No recently played tracks yet.',
                style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              final imageUrl = (item['imageUrl'] ?? '') as String;

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _buildImage(imageUrl),
                ),
                title: Text(
                  item['title'] ?? '',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  item['subtitle'] ?? '',
                  style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () {
                    audioController.removeFromHistory(index);
                  },
                ),
                onTap: null,
              );
            },
          );
        },
      ),
    );
  }
}