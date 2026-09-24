import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,

      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),

      child: TextField(
        controller: controller,

        style: const TextStyle(color: Colors.black),

        decoration: const InputDecoration(
          border: InputBorder.none,

          hintText: "Apa yang ingin kamu dengarkan?",

          hintStyle: TextStyle(color: Colors.grey),

          prefixIcon: Icon(Icons.search, color: Colors.black),
        ),
      ),
    );
  }
}
