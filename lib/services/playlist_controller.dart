import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song_model.dart';

class PlaylistController extends ChangeNotifier {
  static final PlaylistController instance = PlaylistController._internal();
  factory PlaylistController() => instance;

  PlaylistController._internal() {
    _loadFromStorage(); // Memuat data tersimpan saat controller diinisialisasi
  }

  static const String _storageKey = 'user_playlists_storage';

  final List<Map<String, dynamic>> _userPlaylists = [
    {
      'name': 'Top Hits Indonesia',
      'isPinned': true,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/tophits.jpg',
      'subtitle': 'Popular songs in this week.',
    },
    {
      'name': 'Night Drift',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/nightdrift.jpg',
      'subtitle': 'Empty streets and midnight thoughts.',
    },
    {
      'name': 'Daydream Mix',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/daydream.jpg',
      'subtitle': 'Lost in thoughts, one track at a time.',
    },
    {
      'name': 'Soft Fade',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/softfade.jpg',
      'subtitle': 'Gentle notes for quiet heartbreak.',
    },
    {
      'name': 'Trending Now',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/trending.jpg',
      'subtitle': 'What the world is listening to today.',
    },
    {
      'name': 'Chart Climbers',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/chart.jpg',
      'subtitle': 'The biggest tracks blowing up right now.',
    },
    {
      'name': 'Viva La Vida',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/vivalavida.jpg',
      'subtitle': 'Coldplay',
    },
    {
      'name': 'Starboy',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/starboy.jpg',
      'subtitle': 'The Weeknd',
    },
    {
      'name': 'Bohemian Rhapsody',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/bohemian.jpg',
      'subtitle': 'Queen',
    },
    {
      'name': 'Monokrom',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/monokrom.jpg',
      'subtitle': 'Tulus',
    },
    {
      'name': 'Blue Hour',
      'subtitle': 'Soft melodies for heavy feelings.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/bluehour.jpg',
    },
    {
      'name': 'Starlight',
      'subtitle': 'Sountrack for your late-night strolls.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/starlight.jpg',
    },
    {
      'name': 'After Hours',
      'subtitle': 'Neon lights and quiet beats.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/afterhours.jpg',
    },
    {
      'name': 'Melancholy',
      'subtitle': 'Raw, honest songs that understand.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/melancholy.jpg',
    },
    {
      'name': 'Focus Flow',
      'subtitle': 'Zero distractions, pure productivity.',
      'isPinned': true,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/focus.jpg',
    },
    {
      'name': 'Deep Zone',
      'subtitle': 'Ambient soundscapes to lock you in.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/deepzone.jpg',
    },
    {
      'name': 'Hot Right Now',
      'subtitle': 'Viral anthems you cannot skip.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/hotright.jpg',
    },
    {
      'name': 'Power Rush',
      'subtitle': 'High energy to crush your limits.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/powerrush.jpg',
    },
    {
      'name': 'Hype Mix',
      'subtitle': 'Upbeat tracks for maximum drive.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/hypemix.jpg',
    },
    {
      'name': 'Beast Mode',
      'subtitle': 'Heavy bass to fuel the grind.',
      'isPinned': true,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/beastmode.jpg',
    },
  ];

  List<Map<String, dynamic>> get userPlaylists => _userPlaylists;

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final dataToSave = _userPlaylists.map((playlist) {
        final songsList = (playlist['songs'] as List<SongModel>?)?.map((s) {
              return {
                'title': s.title,
                'artist': s.artist,
                'audioUrl': s.audioUrl,
                'albumCover': s.albumCover,
              };
            }).toList() ??
            [];

        return {
          'id': playlist['id'],
          'name': playlist['name'],
          'isPinned': playlist['isPinned'] ?? false,
          'isUserCreated': playlist['isUserCreated'] ?? false,
          'imageUrl': playlist['imageUrl'],
          'subtitle': playlist['subtitle'],
          'songs': songsList,
        };
      }).toList();

      await prefs.setString(_storageKey, jsonEncode(dataToSave));
    } catch (e) {
      debugPrint('Error saving playlists: $e');
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);

        _userPlaylists.clear();

        for (var item in decoded) {
          final map = Map<String, dynamic>.from(item);
          final songsList = (map['songs'] as List<dynamic>?)?.map((s) {
                final songMap = Map<String, dynamic>.from(s);
                return SongModel(
                  title: songMap['title'] ?? '',
                  artist: songMap['artist'] ?? '',
                  audioUrl: songMap['audioUrl'] ?? '',
                  albumCover: songMap['albumCover'] ?? '',
                );
              }).toList() ??
              <SongModel>[];

          _userPlaylists.add({
            'id': map['id'],
            'name': map['name'],
            'isPinned': map['isPinned'] ?? false,
            'isUserCreated': map['isUserCreated'] ?? false,
            'imageUrl': map['imageUrl'],
            'subtitle': map['subtitle'],
            'songs': songsList,
          });
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading playlists: $e');
    }
  }


  int _findPlaylistIndex(dynamic keyOrName) {
    return _userPlaylists.indexWhere(
      (p) => p['id'] == keyOrName || p['name'] == keyOrName,
    );
  }

  void togglePin(String playlistName) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      _userPlaylists[index]['isPinned'] =
          !(_userPlaylists[index]['isPinned'] ?? false);
      _saveToStorage();
      notifyListeners();
    }
  }

  void addSongToPlaylist(String playlistName, SongModel song) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      final List<SongModel> songs =
          List<SongModel>.from(_userPlaylists[index]['songs'] ?? []);
      final exists = songs.any((s) =>
          s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
      if (!exists) {
        songs.add(song);
        _userPlaylists[index]['songs'] = songs;
        _saveToStorage();
        notifyListeners();
      }
    }
  }

  void removeSongFromPlaylist(String playlistName, SongModel song) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      final List<SongModel> songs =
          List<SongModel>.from(_userPlaylists[index]['songs'] ?? []);
      songs.removeWhere((s) =>
          s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
      _userPlaylists[index]['songs'] = songs;
      _saveToStorage();
      notifyListeners();
    }
  }

  void createNewPlaylist(String name) {
    _userPlaylists.add({
      'id': 'user_playlist_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'isPinned': false,
      'isUserCreated': true,
      'songs': <SongModel>[],
    });
    _saveToStorage();
    notifyListeners();
  }

  void renamePlaylist(String oldNameOrId, String newName) {
    final index = _findPlaylistIndex(oldNameOrId);
    if (index != -1) {
      _userPlaylists[index]['name'] = newName;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deletePlaylist(dynamic itemOrKey) {
    if (itemOrKey is Map<String, dynamic>) {
      _userPlaylists.removeWhere(
        (p) =>
            (itemOrKey['id'] != null && p['id'] == itemOrKey['id']) ||
            p['name'] == itemOrKey['name'],
      );
    } else if (itemOrKey is String) {
      _userPlaylists.removeWhere(
        (p) => p['id'] == itemOrKey || p['name'] == itemOrKey,
      );
    }
    _saveToStorage();
    notifyListeners();
  }
}