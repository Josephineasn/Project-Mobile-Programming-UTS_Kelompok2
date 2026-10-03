import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Apa yang ingin kamu dengarkan?',
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black54, size: 20),
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}