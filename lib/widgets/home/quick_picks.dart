import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class QuickPicks extends StatelessWidget {
  final List<Map<String, String>> items;
  final String activePlayingTitle;
  final bool isPlaying;
  final Function(Map<String, String>) onItemTap;
  final Function(Map<String, String>) onPlayTap;

  const QuickPicks({
    super.key,
    required this.items,
    required this.activePlayingTitle,
    required this.isPlaying,
    required this.onItemTap,
    required this.onPlayTap,
  });

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 56,
          height: 56,
          color: Colors.grey.shade800,
          child: const Icon(Icons.music_note, color: Colors.white54),
        ),
      );
    }
    return Image.asset(
      path,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => Container(
        width: 56,
        height: 56,
        color: Colors.grey.shade800,
        child: const Icon(Icons.music_note, color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayItems = items.take(6).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Picks',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 56,
            ),
            itemBuilder: (context, index) {
              final item = displayItems[index];
              final itemTitle = item['title'] ?? '';
              final isItemPlaying = isPlaying && activePlayingTitle == itemTitle;

              return GestureDetector(
                onTap: () => onItemTap(item),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF22252E) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                        child: _buildImage(item['imageUrl'] ?? ''),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          itemTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isItemPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () => onPlayTap(item),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}