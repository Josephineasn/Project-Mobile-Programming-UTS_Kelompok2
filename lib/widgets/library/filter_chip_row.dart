import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class FilterChipRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const FilterChipRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const List<Map<String, dynamic>> filterOptions = [
    {
      'label': 'All',
      'type': 'type',
      'icon': Icons.grid_view_rounded,
      'color': AppColors.primaryGreen,
    },
    {
      'label': 'Deep Focus',
      'type': 'type',
      'icon': Icons.bolt_rounded,
      'color': Color(0xFFC084FC),
    },
    {
      'label': 'Midnight Walk',
      'type': 'type',
      'icon': Icons.nightlight_round,
      'color': Color(0xFF579FF4),
    },
    {
      'label': 'Workout Boost',
      'type': 'category',
      'icon': Icons.local_fire_department_rounded,
      'color': Color(0xFFFFB703),
    },
    {
      'label': 'Melancholy',
      'type': 'category',
      'icon': Icons.cloudy_snowing,
      'color': Color(0xFFC084FC),
    },
    {
      'label': 'Trending Spotlight',
      'type': 'category',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFFE8FD52),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final String label = filter['label'];
          final IconData icon = filter['icon'];
          final Color accentColor = filter['color'];
          final isSelected = selectedFilter == label;

          return GestureDetector(
            onTap: () {
              onFilterSelected(isSelected ? '' : label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.18)
                    : (isDark ? const Color(0xFF191B22) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? accentColor : (isDark ? Colors.white12 : Colors.black12),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? accentColor : (isDark ? Colors.white60 : Colors.black54),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.white : Colors.black)
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}