import 'package:flutter/material.dart';

class FilterChipRow extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const FilterChipRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filters = ['Playlists', 'Artists'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                onFilterSelected(isSelected ? '' : filter);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1DB954)
                      : (isDark ? const Color(0xFF282828) : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : (isDark ? Colors.white : Colors.black87),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}