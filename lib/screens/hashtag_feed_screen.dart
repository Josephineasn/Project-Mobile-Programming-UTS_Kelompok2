import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/song_model.dart';
import '../services/audio_controller.dart';

class HashtagFeedScreen extends StatefulWidget {
  final String title;
  final String image;
  final Future<List<SongModel>> songsFuture;

  const HashtagFeedScreen({
    super.key,
    required this.title,
    required this.image,
    required this.songsFuture,
  });

  @override
  State<HashtagFeedScreen> createState() => _HashtagFeedScreenState();
}

class _HashtagFeedScreenState extends State<HashtagFeedScreen> {
  final AudioController _audioController = AudioController.instance;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);
  }

  void _onAudioChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    _pageController.dispose();
    super.dispose();
  }

  bool _isPlayingSong(SongModel song) =>
      _audioController.isPlaying &&
      _audioController.currentSong?.audioUrl == song.audioUrl;

  Future<void> _toggleSong(List<SongModel> songs, int index) async {
    final song = songs[index];
    if (song.audioUrl.isEmpty) return;

    if (_audioController.currentSong?.audioUrl == song.audioUrl) {
      await _audioController.togglePlayPause();
      return;
    }

    await _audioController.setPlaylist(
      songs,
      initialIndex: index,
      autoPlay: true,
      playlistName: widget.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<SongModel>>(
        future: widget.songsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _FeedMessage(
              message: 'Lagu gagal dimuat. Periksa koneksi internet.',
              onBack: () => Navigator.of(context).pop(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          final songs = snapshot.data!;
          if (songs.isEmpty) {
            return _FeedMessage(
              message: 'Belum ada lagu untuk ditampilkan.',
              onBack: () => Navigator.of(context).pop(),
            );
          }

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: songs.length,
            onPageChanged: (index) async {
              if (_currentIndex < songs.length &&
                  _isPlayingSong(songs[_currentIndex])) {
                await _audioController.togglePlayPause();
              }
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
            itemBuilder: (context, index) {
              final song = songs[index];
              return _FeedPost(
                title: widget.title,
                poster: song.albumCover,
                fallbackImage: widget.image,
                song: song,
                isCurrent: index == _currentIndex,
                isPlaying: _isPlayingSong(song),
                onPlay: () => _toggleSong(songs, index),
                isVideo: index % 4 != 3,
              );
            },
          );
        },
      ),
    );
  }
}

class _FeedPost extends StatelessWidget {
  final String title;
  final String poster;
  final String fallbackImage;
  final SongModel song;
  final bool isCurrent;
  final bool isPlaying;
  final bool isVideo;
  final VoidCallback onPlay;

  const _FeedPost({
    required this.title,
    required this.poster,
    required this.fallbackImage,
    required this.song,
    required this.isCurrent,
    required this.isPlaying,
    required this.isVideo,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (isVideo && isCurrent)
          _VideoBackdrop(poster: poster, fallbackImage: fallbackImage)
        else
          _ImageBackdrop(poster: poster, fallbackImage: fallbackImage),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent, Colors.black87],
              stops: [0, 0.42, 1],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onPlay,
                      tooltip: isPlaying ? 'Jeda lagu' : 'Putar lagu',
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.volume_up_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!isVideo)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Icon(Icons.image_outlined, color: Colors.white70),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.artist.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            song.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title.startsWith('#') ? title : '#trendingmusic',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _SongStrip(
                            song: song,
                            onPlay: onPlay,
                            isPlaying: isPlaying,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundImage: _networkImage(poster),
                          child: poster.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(height: 18),
                        IconButton(
                          onPressed: onPlay,
                          tooltip: isPlaying ? 'Jeda lagu' : 'Putar lagu',
                          icon: Icon(
                            isPlaying ? Icons.pause_circle : Icons.play_circle,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VideoBackdrop extends StatefulWidget {
  final String poster;
  final String fallbackImage;

  const _VideoBackdrop({required this.poster, required this.fallbackImage});

  @override
  State<_VideoBackdrop> createState() => _VideoBackdropState();
}

class _VideoBackdropState extends State<_VideoBackdrop> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
            ),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..initialize()
              .then((_) {
                if (mounted) {
                  _controller.setVolume(0).then((_) {
                    if (!mounted) return;
                    _controller
                      ..setLooping(true)
                      ..play();
                    setState(() {});
                  });
                }
              })
              .catchError((Object _) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized || _controller.value.hasError) {
      return _ImageBackdrop(
        poster: widget.poster,
        fallbackImage: widget.fallbackImage,
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

class _ImageBackdrop extends StatelessWidget {
  final String poster;
  final String fallbackImage;

  const _ImageBackdrop({required this.poster, required this.fallbackImage});

  @override
  Widget build(BuildContext context) {
    if (poster.isNotEmpty) {
      return Image.network(
        poster,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(fallbackImage, fit: BoxFit.cover),
      );
    }
    return Image.asset(fallbackImage, fit: BoxFit.cover);
  }
}

class _SongStrip extends StatelessWidget {
  final SongModel song;
  final VoidCallback onPlay;
  final bool isPlaying;

  const _SongStrip({
    required this.song,
    required this.onPlay,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 48,
              height: 48,
              child: song.albumCover.isEmpty
                  ? const ColoredBox(
                      color: Colors.white12,
                      child: Icon(Icons.music_note, color: Colors.white),
                    )
                  : Image.network(
                      song.albumCover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                            color: Colors.white12,
                            child: Icon(Icons.music_note, color: Colors.white),
                          ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lagu • ${song.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onPlay,
            tooltip: isPlaying ? 'Jeda lagu' : 'Putar lagu',
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

ImageProvider<Object>? _networkImage(String url) =>
    url.isEmpty ? null : NetworkImage(url);

class _FeedMessage extends StatelessWidget {
  final String message;
  final VoidCallback onBack;

  const _FeedMessage({required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            TextButton(onPressed: onBack, child: const Text('Kembali')),
          ],
        ),
      ),
    );
  }
}
