import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/song_model.dart';
import '../services/audio_controller.dart';
import '../services/song_service.dart';
import 'hashtag_feed_screen.dart';
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

  final TextEditingController _searchController = TextEditingController();
  final AudioController _audioController = AudioController.instance;

  List<SongModel> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    try {
      final results = await SongService.searchDeezerSongs(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openCategory(String title, List<SongModel> songs) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _CategorySongsScreen(title: title, songs: songs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey : Colors.grey.shade600;
    final currentSong = _audioController.currentSong;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'search',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                  Text(
                    'Cari',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: textColor,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomSearchBar(
                controller: _searchController,
                onChanged: (query) => _performSearch(query),
                onClear: () {
                  _searchController.clear();
                  _performSearch('');
                },
              ),
              const SizedBox(height: 24),
              if (_isSearching) ...[
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: Color(0xFF1DB954)),
                    ),
                  )
                else if (_searchResults.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(
                        'Tidak ada lagu ditemukan',
                        style: TextStyle(color: subTextColor),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final song = _searchResults[index];
                      final isCurrent = currentSong?.audioUrl == song.audioUrl;
                      final isPlaying = isCurrent && _audioController.isPlaying;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: song.albumCover.isNotEmpty
                              ? Image.network(
                                  song.albumCover,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey,
                                  child: const Icon(Icons.music_note),
                                ),
                        ),
                        title: Text(
                          song.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isCurrent ? const Color(0xFF1DB954) : textColor,
                            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          song.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: subTextColor),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: const Color(0xFF1DB954),
                            size: 32,
                          ),
                          onPressed: () {
                            if (isCurrent) {
                              _audioController.togglePlayPause();
                            } else {
                              _audioController.setPlaylist(_searchResults, initialIndex: index);
                            }
                          },
                        ),
                        onTap: () {
                          if (isCurrent) {
                            _audioController.togglePlayPause();
                          } else {
                            _audioController.setPlaylist(_searchResults, initialIndex: index);
                          }
                        },
                      );
                    },
                  ),
              ] else ...[
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
                Text(
                  'Temukan sesuatu yang lain',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 230,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SearchCard(
                        title: '#timor hip hop',
                        image: 'assets/images/hiphop.jpg',
                        onTap: () => _openHashtagFeed(
                          context,
                          '#timor hip hop',
                          'assets/images/hiphop.jpg',
                          _songsFuture,
                        ),
                      ),
                      SearchCard(
                        title: '#happy dance',
                        image: 'assets/images/dance.jpg',
                        onTap: () => _openHashtagFeed(
                          context,
                          '#happy dance',
                          'assets/images/dance.jpg',
                          _songsFuture,
                        ),
                      ),
                      SearchCard(
                        title: 'Trending Music',
                        image: 'assets/images/music.jpg',
                        onTap: () => _openHashtagFeed(
                          context,
                          'Trending Music',
                          'assets/images/music.jpg',
                          _songsFuture,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

void _openHashtagFeed(
  BuildContext context,
  String title,
  String image,
  Future<List<SongModel>> songsFuture,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => HashtagFeedScreen(
        title: title,
        image: image,
        songsFuture: songsFuture,
      ),
    ),
  );
}

class _CategorySongsScreen extends StatefulWidget {
  final String title;
  final List<SongModel> songs;

  const _CategorySongsScreen({required this.title, required this.songs});

  @override
  State<_CategorySongsScreen> createState() => _CategorySongsScreenState();
}

class _CategorySongsScreenState extends State<_CategorySongsScreen> {
  final AudioController _audioController = AudioController.instance;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final itemTextColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final currentSong = _audioController.currentSong;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: itemTextColor,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: widget.songs.length,
        itemBuilder: (context, index) {
          final song = widget.songs[index];
          final isCurrent = currentSong?.audioUrl == song.audioUrl;
          final isPlaying = isCurrent && _audioController.isPlaying;

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.albumCover,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  width: 52,
                  height: 52,
                  child: ColoredBox(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                    child: Icon(
                      Icons.music_note,
                      color: isDark ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isCurrent ? const Color(0xFF1DB954) : itemTextColor,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: subTextColor),
            ),
            trailing: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: isCurrent ? const Color(0xFF1DB954) : itemTextColor,
            ),
            onTap: () {
              if (isCurrent) {
                _audioController.togglePlayPause();
              } else {
                _audioController.setPlaylist(widget.songs, initialIndex: index);
              }
            },
          );
        },
      ),
    );
  }
}