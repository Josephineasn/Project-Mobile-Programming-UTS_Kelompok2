import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),

            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[900],
              child: const Icon(Icons.music_note, size: 80, color: Colors.green),
            ),

            const Spacer(),

            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'As It Was',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Harry Styles',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Icon(Icons.favorite_border, color: Colors.white),
            ),

            Slider(
              value: 0.3,
              activeColor: Colors.green,
              inactiveColor: Colors.grey[800],
              onChanged: (val) {},
            ),

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