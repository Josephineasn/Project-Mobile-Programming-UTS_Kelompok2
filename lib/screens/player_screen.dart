import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 
import '../models/song_model.dart';
import '../services/song_service.dart';
import '../widgets/player/album_art_view.dart';
import '../widgets/player/song_progress_bar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late Future<List<SongModel>> _songsFuture;
  final AudioPlayer _audioPlayer = AudioPlayer(); 
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _songsFuture = SongService.fetchDeezerSongs();
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); 
    super.dispose();
  }

  Future<void> _togglePlayPause(List<SongModel> songs) async {
    final currentSong = songs[_currentIndex];

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(UrlSource(currentSong.audioUrl));
      setState(() {
        _isPlaying = true;
      });

      _audioPlayer.onPlayerComplete.first.then((_) {
        if (mounted) {
          if (_currentIndex < songs.length - 1) {
            _changeSong(songs, _currentIndex + 1);
          } else {
            _changeSong(songs, 0);
          }
        }
      });
    }
  }

  Future<void> _changeSong(List<SongModel> songs, int newIndex) async {
    await _audioPlayer.stop();
    setState(() {
      _currentIndex = newIndex;
      _isPlaying = false;
    });
    _togglePlayPause(songs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Now Playing', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _songsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat lagu: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          final songs = snapshot.data!;
          final currentSong = songs[_currentIndex];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              children: [
                AlbumArtView(
                  height: 260.0,
                  imageUrl: currentSong.albumCover,
                ),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.title,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.green : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                SongProgressBar(audioPlayer: _audioPlayer),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                      onPressed: _currentIndex > 0
                          ? () => _changeSong(songs, _currentIndex - 1)
                          : null,
                    ),
                    IconButton(
                      iconSize: 64,
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white,
                      ),
                      onPressed: () => _togglePlayPause(songs),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                      onPressed: _currentIndex < songs.length - 1
                          ? () => _changeSong(songs, _currentIndex + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}