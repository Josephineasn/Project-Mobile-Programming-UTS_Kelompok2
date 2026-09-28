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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ChoiceChip(
            shape: const StadiumBorder(),
            side: BorderSide.none,
            label: Text(
              'Playlists',
              style: TextStyle(
                color: selectedFilter == 'Playlists' ? Colors.black : Colors.white,
              ),
            ),
            selected: selectedFilter == 'Playlists',
            selectedColor: Colors.green,
            backgroundColor: Colors.grey[900],
            showCheckmark: false,
            onSelected: (selected) {
              onFilterSelected(selected ? 'Playlists' : '');
            },
          ),
          const SizedBox(width: 12),
          ChoiceChip(
            shape: const StadiumBorder(),
            side: BorderSide.none,
            label: Text(
              'Artist',
              style: TextStyle(
                color: selectedFilter == 'Artist' ? Colors.black : Colors.white,
              ),
            ),
            selected: selectedFilter == 'Artist',
            selectedColor: Colors.green,
            backgroundColor: Colors.grey[900],
            showCheckmark: false,
            onSelected: (selected) {
              onFilterSelected(selected ? 'Artist' : '');
            },
          ),
        ],
      ),
    );
  }
}