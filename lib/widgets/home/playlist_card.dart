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
        // Warna dasar kartu
        color: isDark ? const Color(0xFF242424) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPlaying ? AppColors.primaryGreen : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPlayTap,
            child: Row(
              children: [
                // Gambar Cover Lagu
                Image.network(
                  imageUrl,
                  width: 58,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  cacheWidth: 150,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 58,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade400,
                    child: const Icon(Icons.music_note, color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 10),

                // Judul Playlist
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // Teks jadi hijau kalau lagi play, kalau tidak warnanua tetap putih/hitam
                      color: isPlaying
                          ? AppColors.primaryGreen
                          : (isDark ? Colors.white : Colors.black87),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),

                // Tombol buat play pause
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                  child: GestureDetector(
                    onTap: onPlayTap,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? AppColors.primaryGreen
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.black.withValues(alpha: 0.08)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: isPlaying
                            ? Colors.black
                            : (isDark ? Colors.white : Colors.black87),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.7,
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