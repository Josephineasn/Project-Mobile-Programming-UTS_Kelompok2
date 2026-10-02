import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isPlaying;
  final VoidCallback onPlayTap;

  const PlaylistCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isPlaying,
    required this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // Kalau lagi di play (isPlaying true), kotaknya kasih warna hijau tipis
        color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          // Kalau lagi di play, kasih garis pinggir hijau
          color: isPlaying ? AppColors.primaryGreen : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Gambar Cover Lagu
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
            ),
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              cacheWidth: 150,
            ),
          ),
          const SizedBox(width: 8),

          // Judul Playlist
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                // Teks jadi hijau kalau lagi play
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tombol buat  play pause
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: GestureDetector(
              onTap: onPlayTap,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  // Kalau lagi di play warnanya jadi hijau, kalau tidak di play maka warnanya abu-abu
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  // Kalau lagi diplay ikonnya pause, kalau belum ikonnya play
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistCardGrid extends StatefulWidget {
  final List<Map<String, String>> items;

  const PlaylistCardGrid({
    super.key,
    required this.items,
  });

  @override
  State<PlaylistCardGrid> createState() => _PlaylistCardGridState();
}

class _PlaylistCardGridState extends State<PlaylistCardGrid> {
  int playingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.8,
        ),
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return PlaylistCard(
            title: item['title'] ?? '',
            imageUrl: item['imageUrl'] ?? '',
            isPlaying: playingIndex == index,
            onPlayTap: () {
              setState(() {
                if (playingIndex == index) {
                  playingIndex = -1;
                } else {
                  playingIndex = index;
                }
              });
            },
          );
        },
      ),
    );
  }
}