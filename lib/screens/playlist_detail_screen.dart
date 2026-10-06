import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/song_model.dart';
import '../services/song_service.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Gabung status listener audio dan auto-fetch lagu Deezer dalam 1 alur awal
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    List<SongModel> currentSongs = List<SongModel>.from(
      widget.playlist['songs'] ?? [],
    );
    if (currentSongs.isEmpty) {
      _loadInitialSongs();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadInitialSongs() async {
    setState(() => _isLoading = true);
    try {
      final fetchedSongs = await SongService.fetchDeezerSongs();
      if (mounted) setState(() => widget.playlist['songs'] = fetchedSongs);
    } catch (e) {
      debugPrint('Error fetching songs: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _playPauseSong(String audioUrl) async {
    if (audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preview audio not available for this song.'),
        ),
      );
      return;
    }

    if (_currentlyPlayingUrl == audioUrl && _isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
      setState(() => _currentlyPlayingUrl = audioUrl);
    }
  }

  void _showAddSongDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF282828) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        title: Text(
          'Pick a Song',
          style: TextStyle(color: textColor, fontSize: 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: FutureBuilder<List<SongModel>>(
            future: SongService.fetchDeezerSongs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1DB954)),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load songs:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final apiSongs = snapshot.data ?? [];
              if (apiSongs.isEmpty) {
                return const Center(
                  child: Text(
                    'No songs found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              List<SongModel> currentPlaylistSongs = List<SongModel>.from(
                widget.playlist['songs'] ?? [],
              );

              return ListView.builder(
                shrinkWrap: true,
                itemCount: apiSongs.length,
                itemBuilder: (context, index) {
                  final song = apiSongs[index];
                  final isAlreadyInPlaylist = currentPlaylistSongs.any(
                    (s) => s.title == song.title,
                  );

                  return ListTile(
                    leading: song.albumCover.isNotEmpty
                        ? Image.network(
                            song.albumCover,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.music_note,
                              color: Colors.green,
                            ),
                          )
                        : const Icon(Icons.music_note, color: Colors.green),
                    title: Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: textColor),
                    ),
                    subtitle: Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: isAlreadyInPlaylist
                        ? const Icon(Icons.check, color: Colors.grey)
                        : IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              setState(
                                () => widget.playlist['songs'].add(song),
                              );
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Adding "${song.title}" to playlist',
                                  ),
                                ),
                              );
                            },
                          ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showDeleteSongDialog(SongModel song) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF282828) : Colors.white,
        title: Text(
          'Delete Song?',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Delete "${song.title}" from playlist "${widget.playlist['name']}"?',
          style: TextStyle(color: isDark ? Colors.grey : Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (song.audioUrl.isNotEmpty &&
                  song.audioUrl == _currentlyPlayingUrl){
                _audioPlayer.stop();
              }
              setState(() => widget.playlist['songs'].remove(song));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Delete "${song.title}"')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    List<SongModel> songs = List<SongModel>.from(
      widget.playlist['songs'] ?? [],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.playlist['name'],
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.queue_music, color: Colors.green),
            onPressed: _showAddSongDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)),
            )
          : songs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Playlist is empty',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1DB954),
                    ),
                    onPressed: _showAddSongDialog,
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text(
                      'Add Song',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                SongModel song = songs[index];
                final isCurrentSongPlaying =
                    _currentlyPlayingUrl == song.audioUrl && _isPlaying;

                return ListTile(
                  onTap: () => _playPauseSong(song.audioUrl),
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: song.albumCover.isNotEmpty
                            ? Image.network(song.albumCover, fit: BoxFit.cover)
                            : Icon(
                                Icons.music_note,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                      ),
                      if (isCurrentSongPlaying)
                        Container(
                          width: 48,
                          height: 48,
                          color: Colors.black54,
                          child: const Icon(Icons.pause, color: Colors.white),
                        ),
                    ],
                  ),
                  title: Text(
                    song.title,
                    style: TextStyle(
                      color: isCurrentSongPlaying
                          ? const Color(0xFF1DB954)
                          : textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isCurrentSongPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: const Color(0xFF1DB954),
                        ),
                        onPressed: () => _playPauseSong(song.audioUrl),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () => _showDeleteSongDialog(song),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
