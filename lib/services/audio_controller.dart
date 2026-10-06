import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _hasPlayedBefore = false;
  final List<SongModel> _likedSongs = [];

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get hasPlayedBefore => _hasPlayedBefore;
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

    _player.onPositionChanged.listen((position) {
      if (_isPlaying) {
        _saveLastPlayedState(position);
      }
    });
  }

  Future<void> setPlaylist(
    List<SongModel> songs, {
    int initialIndex = 0,
    bool autoPlay = true,
  }) async {
    _playlist = songs;
    _currentIndex = initialIndex;
    if (currentSong != null) {
      if (autoPlay) {
        await playSong(currentSong!);
      } else {
        await _player.setSource(UrlSource(currentSong!.audioUrl));
        await _player.pause();
        _isPlaying = false;
        notifyListeners();
      }
    }
  }

  Future<void> playSong(SongModel song) async {
    if (song.audioUrl.isEmpty) return;
    _hasPlayedBefore = true;
    await _player.stop();
    await _player.play(UrlSource(song.audioUrl));
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      if (currentSong != null) {
        _hasPlayedBefore = true;
        if (_player.state == PlayerState.paused) {
          await _player.resume();
        } else {
          await playSong(currentSong!);
        }
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
    _saveLikedSongs(); 
    notifyListeners();
  }

  bool isLiked(SongModel song) {
    return _likedSongs.any((s) => s.title == song.title);
  }

  Future<void> _saveLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final likedData = _likedSongs.map((song) => {
      'title': song.title,
      'artist': song.artist,
      'audioUrl': song.audioUrl,
      'albumCover': song.albumCover,
    }).toList();
    
    await prefs.setString('liked_songs_json', jsonEncode(likedData));
  }

  Future<void> loadLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? likedJson = prefs.getString('liked_songs_json');
    if (likedJson != null) {
      final List<dynamic> decoded = jsonDecode(likedJson);
      _likedSongs.clear();
      for (var item in decoded) {
        _likedSongs.add(SongModel(
          title: item['title'] ?? '',
          artist: item['artist'] ?? '',
          audioUrl: item['audioUrl'] ?? '',
          albumCover: item['albumCover'] ?? '',
        ));
      }
      notifyListeners();
    }
  }

  Future<void> _saveLastPlayedState(Duration position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_played_before', true);
    await prefs.setInt('last_song_index', _currentIndex);
    await prefs.setInt('last_position_ms', position.inMilliseconds);
  }

  Future<void> loadLastPlayedState() async {
    if (_playlist.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _hasPlayedBefore = prefs.getBool('has_played_before') ?? false;

    if (!_hasPlayedBefore) return;

    final savedIndex = prefs.getInt('last_song_index') ?? 0;
    final savedPositionMs = prefs.getInt('last_position_ms') ?? 0;

    if (savedIndex < _playlist.length) {
      _currentIndex = savedIndex;
      if (currentSong != null) {
        await _player.setSource(UrlSource(currentSong!.audioUrl));
        if (savedPositionMs > 0) {
          await _player.seek(Duration(milliseconds: savedPositionMs));
        }
        await _player.pause();
        _isPlaying = false;
      }
    }
    notifyListeners();
  }
}