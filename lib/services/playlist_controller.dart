import 'package:flutter/material.dart';
import '../models/song_model.dart';

class PlaylistController extends ChangeNotifier {
  static final PlaylistController instance = PlaylistController._internal();
  factory PlaylistController() => instance;
  PlaylistController._internal();

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

  int _findPlaylistIndex(dynamic keyOrName) {
    return _userPlaylists.indexWhere(
      (p) => p['id'] == keyOrName || p['name'] == keyOrName,
    );
  }

  void togglePin(String playlistName) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      _userPlaylists[index]['isPinned'] = !(_userPlaylists[index]['isPinned'] ?? false);
      notifyListeners();
    }
  }

  void addSongToPlaylist(String playlistName, SongModel song) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      final List<SongModel> songs = List<SongModel>.from(_userPlaylists[index]['songs'] ?? []);
      final exists = songs.any((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
      if (!exists) {
        songs.add(song);
        _userPlaylists[index]['songs'] = songs;
        notifyListeners();
      }
    }
  }

  void removeSongFromPlaylist(String playlistName, SongModel song) {
    final index = _findPlaylistIndex(playlistName);
    if (index != -1) {
      final List<SongModel> songs = List<SongModel>.from(_userPlaylists[index]['songs'] ?? []);
      songs.removeWhere((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
      _userPlaylists[index]['songs'] = songs;
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
    notifyListeners();
  }

  /// Mengubah nama playlist berdasarkan nama lama atau ID
  void renamePlaylist(String oldNameOrId, String newName) {
    final index = _findPlaylistIndex(oldNameOrId);
    if (index != -1) {
      _userPlaylists[index]['name'] = newName;
      notifyListeners();
    }
  }

  /// Menghapus playlist (Menerima parameter berupa `Map<String, dynamic>` atau `String` ID/Name)
  void deletePlaylist(dynamic itemOrKey) {
    if (itemOrKey is Map<String, dynamic>) {
      _userPlaylists.removeWhere(
        (p) => (itemOrKey['id'] != null && p['id'] == itemOrKey['id']) ||
            p['name'] == itemOrKey['name'],
      );
    } else if (itemOrKey is String) {
      _userPlaylists.removeWhere(
        (p) => p['id'] == itemOrKey || p['name'] == itemOrKey,
      );
    }
    notifyListeners();
  }
}