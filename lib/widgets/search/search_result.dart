import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  final String title;

  const SearchResult({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: const CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(Icons.music_note, color: Colors.black),
      ),

      title: Text(title, style: const TextStyle(color: Colors.white)),

      subtitle: const Text(
        "Song • Artist",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
