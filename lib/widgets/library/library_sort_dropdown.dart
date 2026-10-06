import 'package:flutter/material.dart';

class LibrarySortDropdown extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortChanged;
  final bool isGridView;
  final VoidCallback onToggleLayout;

  const LibrarySortDropdown({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
    required this.isGridView,
    required this.onToggleLayout,
  });

  String _getSortLabel(String option) {
    if (option == 'alphabet') {
      return 'Alphabet';
    } else if (option == 'SongCount') {
      return 'Song Count';
    } else {
      return 'Latest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<String>(
          initialValue: selectedSort,
          onSelected: onSortChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_vert_rounded,
                  size: 18,
                  color: Color(0xFF1DB954),
                ),
                const SizedBox(width: 6),
                Text(
                  _getSortLabel(selectedSort),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'Latest',
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: selectedSort == 'Latest'
                        ? const Color(0xFF1DB954)
                        : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Latest',
                    style: TextStyle(
                      color: selectedSort == 'Latest'
                          ? const Color(0xFF1DB954)
                          : textColor,
                      fontWeight: selectedSort == 'Latest'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'alphabet',
              child: Row(
                children: [
                  Icon(
                    Icons.sort_by_alpha_rounded,
                    size: 18,
                    color: selectedSort == 'alphabet'
                        ? const Color(0xFF1DB954)
                        : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Alphabet',
                    style: TextStyle(
                      color: selectedSort == 'alphabet'
                          ? const Color(0xFF1DB954)
                          : textColor,
                      fontWeight: selectedSort == 'alphabet'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'SongCount',
              child: Row(
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    size: 18,
                    color: selectedSort == 'SongCount'
                        ? const Color(0xFF1DB954)
                        : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Song Count',
                    style: TextStyle(
                      color: selectedSort == 'SongCount'
                          ? const Color(0xFF1DB954)
                          : textColor,
                      fontWeight: selectedSort == 'SongCount'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onToggleLayout,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              size: 20,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}