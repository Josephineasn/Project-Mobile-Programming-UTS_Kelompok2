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
      'imageUrl': 'https://i.pinimg.com/1200x/5e/73/1a/5e731a8079818156c4ebe3e928c9e173.jpg',
    },
    {
      'name': 'Calm Night Mix',
      'isPinned': true,
      'songs': <SongModel>[],
      'imageUrl': 'https://i.pinimg.com/1200x/0a/1b/9c/0a1b9c9ba6956f06f7358d9efc9b3949.jpg',
    },
    {
      'name': 'Daily Mix',
      'isPinned': true,
      'songs': <SongModel>[],
      'imageUrl': 'https://i.pinimg.com/736x/fb/4a/67/fb4a67c491ed6c28c0d12eb686f7c395.jpg',
    },
    {
      'name': 'Soft Mix',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://i.pinimg.com/736x/11/4f/e3/114fe33c7abd274985eeb90096a55960.jpg',
    },
    {
      'name': 'My Playlist #17',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://i.pinimg.com/736x/8c/ae/65/8cae65c1e73246ede11231230671b11b.jpg',
    },
    {
      'name': 'Discover Weekly',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://i.pinimg.com/736x/e0/10/d4/e010d45a9468f1265eac61d58dfaec94.jpg',
    },
    {
      'name': 'Viva La Vida',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://picsum.photos/seed/coldplay/250',
    },
    {
      'name': 'Starboy',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://picsum.photos/seed/weeknd/250',
    },
    {
      'name': 'Bohemian Rhapsody',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://picsum.photos/seed/queen/250',
    },
    {
      'name': 'Monokrom',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'https://picsum.photos/seed/tulus/250',
    },
    {
      'name': 'Hopeless Romantic Love Mix',
      'subtitle': 'Hopeless Romantic Love music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/hopeless-romantic.jpg',
    },
    {
      'name': 'Yearning Mix',
      'subtitle': 'Yearning music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/yearning.jpg',
    },
    {
      'name': 'Delulu Mix',
      'subtitle': 'Delulu music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/delulu.jpg',
    },
    {
      'name': 'Gentle Love Mix',
      'subtitle': 'Gentle Love music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/gentle-love.jpg',
    },
    {
      'name': 'Situationship Mix',
      'subtitle': 'Situationship for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/situationship.jpg',
    },
    {
      'name': 'Crying Sad Mix',
      'subtitle': 'Crying Sad Music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/crying-sad.jpg',
    },
    {
      'name': 'Moody Sad Mix',
      'subtitle': 'Moody Sad music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/moody-sad.jpg',
    },
    {
      'name': 'Masterpiece Mix',
      'subtitle': 'Masterpiece music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/masterpiece.jpg',
    },
    {
      'name': 'Comforting Mix',
      'subtitle': 'Comforting music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/comforting.jpg',
    },
    {
      'name': 'Fomo Mix',
      'subtitle': 'Fomo music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/fomo.jpg',
    },
    {
      'name': 'Main Character Mix',
      'subtitle': 'Main Character music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/main-character.jpg',
    },
    {
      'name': 'Rizz Mix',
      'subtitle': 'Rizz music for you.',
      'isPinned': false,
      'songs': <SongModel>[],
      'imageUrl': 'assets/images/rizz.jpg',
    },
  ];

  List<Map<String, dynamic>> get userPlaylists => _userPlaylists;

  void addSongToPlaylist(String playlistName, SongModel song) {
    final index = _userPlaylists.indexWhere((p) => p['name'] == playlistName);
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
    final index = _userPlaylists.indexWhere((p) => p['name'] == playlistName);
    if (index != -1) {
      final List<SongModel> songs = List<SongModel>.from(_userPlaylists[index]['songs'] ?? []);
      songs.removeWhere((s) => s.title.trim().toLowerCase() == song.title.trim().toLowerCase());
      _userPlaylists[index]['songs'] = songs;
      notifyListeners();
    }
  }

  void createNewPlaylist(String name) {
    _userPlaylists.add({
      'name': name,
      'isPinned': false,
      'songs': <SongModel>[],
    });
    notifyListeners();
  }

  void deletePlaylist(Map<String, dynamic> item) {
    _userPlaylists.remove(item);
    notifyListeners();
  }
}