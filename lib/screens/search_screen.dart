import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/song_model.dart';
import '../services/song_service.dart';
import '../widgets/search/custom_search_bar.dart';
import '../widgets/search/search_card.dart';
import '../widgets/search/search_category.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final Future<List<SongModel>> _songsFuture =
      SongService.fetchDeezerSongs();

  void _openCategory(String title, List<SongModel> songs) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _CategorySongsScreen(title: title, songs: songs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green[200],
                    child: const Text(
                      'H',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const CustomSearchBar(),
              const SizedBox(height: 24),
              FutureBuilder<List<SongModel>>(
                future: _songsFuture,
                builder: (context, snapshot) {
                  final songs = snapshot.data ?? const <SongModel>[];
                  final categories = <(String, Color, int)>[
                    ('Musik', Colors.pink, 0),
                    ('Podcast', Colors.teal, 1),
                    ('Acara Langsung', Colors.deepPurple, 2),
                    ('K-Pop ON!', Colors.blue, 3),
                  ];

                  return Column(
                    children: [
                      for (var row = 0; row < 2; row++) ...[
                        if (row > 0) const SizedBox(height: 12),
                        Row(
                          children: [
                            for (var column = 0; column < 2; column++) ...[
                              if (column > 0) const SizedBox(width: 12),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final category =
                                        categories[row * 2 + column];
                                    final imageUrl = songs.isEmpty
                                        ? null
                                        : songs[category.$3 % songs.length]
                                              .albumCover;

                                    return SearchCategory(
                                      title: category.$1,
                                      color: category.$2,
                                      imageUrl: imageUrl,
                                      onTap: () {
                                        if (snapshot.hasData &&
                                            songs.isNotEmpty) {
                                          _openCategory(category.$1, songs);
                                          return;
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  snapshot.hasError
                                                      ? 'Lagu gagal dimuat. Coba lagi nanti.'
                                                      : 'Lagu sedang dimuat.',
                                                ),
                                              ),
                                            );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),
              const Text(
                'Temukan sesuatu yang lain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SearchCard(
                      title: '#timor hip hop',
                      image: 'assets/images/hiphop.jpg',
                    ),
                    SearchCard(
                      title: '#happy dance',
                      image: 'assets/images/dance.jpg',
                    ),
                    SearchCard(
                      title: 'Trending Music',
                      image: 'assets/images/music.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySongsScreen extends StatefulWidget {
  final String title;
  final List<SongModel> songs;

  const _CategorySongsScreen({required this.title, required this.songs});

  @override
  State<_CategorySongsScreen> createState() => _CategorySongsScreenState();
}

class _CategorySongsScreenState extends State<_CategorySongsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    final song = widget.songs[index];
    if (song.audioUrl.isEmpty) return;

    await _audioPlayer.play(UrlSource(song.audioUrl));
    if (!mounted) return;
    setState(() {
      _playingIndex = index;
      _isPlaying = true;
    });
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    if (mounted) setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _playingIndex == null
        ? null
        : widget.songs[_playingIndex!];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          final song = widget.songs[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.albumCover,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  width: 52,
                  height: 52,
                  child: ColoredBox(
                    color: Colors.white12,
                    child: Icon(Icons.music_note, color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Icon(
              _playingIndex == index && _isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
            onTap: () {
              if (_playingIndex == index) {
                _togglePlayback();
              } else {
                _playSong(index);
              }
            },
          );
        },
      ),
      bottomNavigationBar: currentSong == null
          ? null
          : SafeArea(
              child: Container(
                color: const Color(0xFF282828),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            currentSong.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _togglePlayback,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
