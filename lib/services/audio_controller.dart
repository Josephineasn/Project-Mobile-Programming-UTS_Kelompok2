import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song_model.dart';

class AudioController extends ChangeNotifier {
  static final AudioController instance = AudioController._internal();
  factory AudioController() => instance;
  AudioController._internal() {
    _initListeners();
  }

  final AudioPlayer _player = AudioPlayer();
  AudioPlayer get player => _player;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  final List<SongModel> _likedSongs = [];

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  List<SongModel> get likedSongs => _likedSongs;

  SongModel? get currentSong =>
      _playlist.isNotEmpty && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  void _initListeners() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((_) {
      playNext();
    });
  }

  Future<void> setPlaylist(List<SongModel> songs, {int initialIndex = 0}) async {
    _playlist = songs;
    _currentIndex = initialIndex;
    if (currentSong != null) {
      await playSong(currentSong!);
    }
  }

  Future<void> playSong(SongModel song) async {
    if (song.audioUrl.isEmpty) return;
    await _player.stop();
    await _player.play(UrlSource(song.audioUrl));
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      if (currentSong != null) {
        await _player.resume();
      }
    }
    notifyListeners();
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    await playSong(_playlist[_currentIndex]);
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _playlist.length - 1;
    }
    await playSong(_playlist[_currentIndex]);
  }

  void toggleLike(SongModel song) {
    if (_likedSongs.any((s) => s.title == song.title)) {
      _likedSongs.removeWhere((s) => s.title == song.title);
    } else {
      _likedSongs.add(song);
    }
    notifyListeners();
  }

  bool isLiked(SongModel song) {
    return _likedSongs.any((s) => s.title == song.title);
  }
}