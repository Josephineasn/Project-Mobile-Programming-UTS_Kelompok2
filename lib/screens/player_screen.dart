import 'package:flutter/material.dart';
import '../widgets/player/album_art_view.dart'; 

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool isLiked = false;
  double progress = 0.3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            const AlbumArtView(height: 260.0),

            const SizedBox(height: 24),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'As It Was',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Harry Styles',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.green : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            Slider(
              value: progress,
              activeColor: Colors.green,
              inactiveColor: Colors.grey[800],
              onChanged: (val) {
                setState(() {
                  progress = val;
                });
              },
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, size: 56, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.speaker, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Text('AirPods Pro', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}