import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song_model.dart';
import '../screens/settings_screen.dart';
import 'premium_controller.dart';

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

  final List<Map<String, dynamic>> _recentlyPlayedHistory = [];
  List<Map<String, dynamic>> get recentlyPlayedHistory => List.unmodifiable(_recentlyPlayedHistory);

  void addToHistory({
    required String title,
    required String subtitle,
    required String imageUrl,
    SongModel? song,
    Map<String, dynamic>? playlist,
  }) {
    _recentlyPlayedHistory.removeWhere((item) => item['title'] == title);
    _recentlyPlayedHistory.insert(0, {
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'playedAt': DateTime.now(),
      'song': song,
      'playlist': playlist,
    });
    notifyListeners();
  }

  String _currentPlaylistName = '';

  bool _isShuffle = false;
  bool _isRepeat = false;

  // Limit skip lagu
  int _skipCount = 0;
  static const int maxFreeSkips = 3;

  /// Cek akun preemium apa ngga
  bool get isCurrentAccountPremium {
    final account = currentAccountNotifier.value;
    return account.isPremium || PremiumController.isPremium.value;
  }

  int get skipCount => _skipCount;
  int get remainingSkips => isCurrentAccountPremium ? 999 : (maxFreeSkips - _skipCount).clamp(0, maxFreeSkips);
  bool get canSkip => isCurrentAccountPremium || _skipCount < maxFreeSkips;

  void resetSkipCount() {
    _skipCount = 0;
    notifyListeners();
  }

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get hasPlayedBefore => _hasPlayedBefore;
  List<SongModel> get likedSongs => _likedSongs;
  String get currentPlaylistName => _currentPlaylistName;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;

  SongModel? get currentSong =>
      _playlist.isNotEmpty && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  void _initListeners() {
    currentAccountNotifier.addListener(() {
      _skipCount = 0;
      notifyListeners();
    });

    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _player.onPlayerComplete.listen((_) {
      playNext(isUserInitiated: false);
    });

    _player.onPositionChanged.listen((position) {
      _saveLastPlayedState(position);
    });
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    if (_isShuffle) {
      _isRepeat = false;
      final playingSong = currentSong;
      _playlist.shuffle();

      if (playingSong != null) {
        _currentIndex = _playlist.indexWhere(
          (song) => song.title.trim().toLowerCase() == playingSong.title.trim().toLowerCase(),
        );
        if (_currentIndex == -1) _currentIndex = 0;
      }
    }
    notifyListeners();
  }

  void removeFromHistory(int index) {
    if (index >= 0 && index < _recentlyPlayedHistory.length) {
      _recentlyPlayedHistory.removeAt(index);
      notifyListeners();
    }
  }

  void clearAllHistory() {
    _recentlyPlayedHistory.clear();
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    if (_isRepeat) {
      _isShuffle = false;
    }
    notifyListeners();
  }

  Future<void> setPlaylist(
    List<SongModel> songs, {
    int initialIndex = 0,
    bool autoPlay = true,
    String playlistName = '',
  }) async {
    if (songs.isEmpty) return;
    _playlist = songs;
    _currentIndex = initialIndex >= 0 && initialIndex < songs.length ? initialIndex : 0;
    if (playlistName.isNotEmpty) {
      _currentPlaylistName = playlistName;
    }
    
    await _saveLastPlayedState(Duration.zero);

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

    addToHistory(
      title: song.title,
      subtitle: song.artist,
      imageUrl: song.albumCover,
      song: song,
    );

    await _saveLastPlayedState(Duration.zero);

    await _player.stop();
    await _player.play(UrlSource(song.audioUrl));
    _isPlaying = true;
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

  Future<bool> playNext({bool isUserInitiated = true}) async {
    if (_playlist.isEmpty) return false;

    if (isUserInitiated && !isCurrentAccountPremium) {
      if (_skipCount >= maxFreeSkips) {
        notifyListeners();
        return false;
      }
      _skipCount++;
    }

    if (_isRepeat && currentSong != null) {
      await playSong(currentSong!);
      return true;
    }

    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    await playSong(_playlist[_currentIndex]);
    return true;
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
    if (_likedSongs.any((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase())) {
      _likedSongs.removeWhere((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
    } else {
      _likedSongs.add(song);
    }
    _saveLikedSongs(); 
    notifyListeners();
  }

  bool isLiked(SongModel song) {
    return _likedSongs.any((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
  }

  Future<void> _saveLikedSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final likedData = _likedSongs.map((song) => {
      'title': song.title,
      'artist': song.artist,
      'audioUrl': song.audioUrl,
      'albumCover': song.albumCover,
      'preview': song.audioUrl,
      'album_cover': song.albumCover,
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
        final url = (item['audioUrl'] ?? item['preview'] ?? '').toString();
        final cover = (item['albumCover'] ?? item['album_cover'] ?? '').toString();

        _likedSongs.add(SongModel(
          title: item['title'] ?? '',
          artist: item['artist'] ?? '',
          audioUrl: url,
          albumCover: cover,
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
    await prefs.setString('last_playlist_name', _currentPlaylistName);

    final playlistData = _playlist.map((song) => {
      'title': song.title,
      'artist': song.artist,
      'audioUrl': song.audioUrl,
      'albumCover': song.albumCover,
      'preview': song.audioUrl,
      'album_cover': song.albumCover,
    }).toList();
    await prefs.setString('last_playlist_json', jsonEncode(playlistData));
  }

  Future<void> loadLastPlayedState() async {
    final prefs = await SharedPreferences.getInstance();
    _hasPlayedBefore = prefs.getBool('has_played_before') ?? false;

    if (!_hasPlayedBefore) return;

    final String? playlistJson = prefs.getString('last_playlist_json');
    final savedIndex = prefs.getInt('last_song_index') ?? 0;
    final savedPositionMs = prefs.getInt('last_position_ms') ?? 0;
    _currentPlaylistName = prefs.getString('last_playlist_name') ?? '';

    if (playlistJson != null && playlistJson.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(playlistJson);
      if (decoded.isNotEmpty) {
        _playlist = decoded.map((item) {
          final url = (item['audioUrl'] ?? item['preview'] ?? '').toString();
          final cover = (item['albumCover'] ?? item['album_cover'] ?? '').toString();
          return SongModel(
            title: item['title'] ?? '',
            artist: item['artist'] ?? '',
            audioUrl: url,
            albumCover: cover,
          );
        }).toList();

        if (savedIndex < _playlist.length) {
          _currentIndex = savedIndex;
          if (currentSong != null && currentSong!.audioUrl.isNotEmpty) {
            await _player.setSource(UrlSource(currentSong!.audioUrl));
            if (savedPositionMs > 0) {
              await _player.seek(Duration(milliseconds: savedPositionMs));
            }
            await _player.pause();
            _isPlaying = false;
          }
        }
      }
    }
    notifyListeners();
  }
}