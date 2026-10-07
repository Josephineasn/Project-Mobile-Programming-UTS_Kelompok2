import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/audio_controller.dart';

class HorizontalPlaylistSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;
  final VoidCallback? onSeeAll;
  final Function(Map<String, String>)? onItemTap;
  final Function(Map<String, String>)? onPlayTap;
  final String activePlayingTitle;

  const HorizontalPlaylistSection({
    super.key,
    required this.title,
    required this.items,
    this.onSeeAll,
    this.onItemTap,
    this.onPlayTap,
    this.activePlayingTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final audioController = AudioController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Bagian
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: onSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Daftar Horizontal
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final imageUrl = item['imageUrl'] ?? '';
              final isAsset = imageUrl.startsWith('assets/');

              return GestureDetector(
                onTap: () {
                  if (onItemTap != null) onItemTap!(item);
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: isAsset
                                ? Image.asset(
                                    imageUrl,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.grey.shade800,
                                      child: const Icon(Icons.music_note, color: Colors.white54),
                                    ),
                                  )
                                : Image.network(
                                    imageUrl,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.grey.shade800,
                                      child: const Icon(Icons.music_note, color: Colors.white54),
                                    ),
                                  ),
                          ),
                          // Tombol Play Hijau / Pause Lingkaran Hitam
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: AnimatedBuilder(
                              animation: audioController,
                              builder: (context, _) {
                                final isCurrentPlaying = audioController.isPlaying &&
                                    ((audioController.currentSong?.title ?? '').toLowerCase() ==
                                            (item['title'] ?? '').toLowerCase() ||
                                        activePlayingTitle.toLowerCase() ==
                                            (item['title'] ?? '').toLowerCase() ||
                                        audioController.currentSong?.albumCover == imageUrl);

                                return GestureDetector(
                                  onTap: () {
                                    if (onPlayTap != null) {
                                      onPlayTap!(item);
                                    }
                                  },
                                  child: _CustomPlayPauseButton(
                                    isPlaying: isCurrentPlaying,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? AppColors.textWhite : Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtitle'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widget tombol Play dan Pause
class _CustomPlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final double size;

  const _CustomPlayPauseButton({
    required this.isPlaying,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (isPlaying) {
      // Pause
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size * 0.15,
                height: size * 0.50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.1),
                ),
              ),
              SizedBox(width: size * 0.15),
              Container(
                width: size * 0.15,
                height: size * 0.50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size * 0.1),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Play
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.black,
          size: size * 0.65,
        ),
      );
    }
  }
}