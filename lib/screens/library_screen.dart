import 'dart:ui';
import 'package:flutter/material.dart';

import '../services/audio_controller.dart';
import '../services/playlist_controller.dart';
import '../widgets/library/playlist_item_tile.dart';
import '../widgets/library/library_header.dart';
import '../widgets/library/add_playlist_button.dart';
import '../widgets/library/filter_chip_row.dart';
import '../widgets/library/library_sort_dropdown.dart';
import '../models/song_model.dart';
import 'playlist_detail_screen.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  final AudioController _audioController = AudioController.instance;
  final PlaylistController _playlistController = PlaylistController.instance;

  String selectedFilter = '';
  bool isSearching = false;
  String searchQuery = '';
  String _currentSort = 'Latest';
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onStateChanged);
    _playlistController.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _audioController.removeListener(_onStateChanged);
    _playlistController.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> get sortedPlaylists {
    List<Map<String, dynamic>> rawPlaylists = [
      {
        'id': 'liked_songs',
        'name': 'Liked Songs',
        'isPinned': true,
        'isLikedSongs': true,
        'type': 'Playlists',
        'category': 'All',
        'songs': List<SongModel>.from(_audioController.likedSongs),
        'imageUrl': 'assets/images/likedsongs.png',
        'subtitle': 'Your favorite tracks, all in one place.',
      },
      {
        'id': 'daydream_mix',
        'name': 'Daydream Mix',
        'type': 'Playlists',
        'category': 'Deep Focus',
        'subtitle': 'Lost in thoughts, one track at a time.',
        'imageUrl': 'assets/images/daydream.jpg',
      },
      {
        'id': 'focus_flow',
        'name': 'Focus Flow',
        'isPinned': true,
        'type': 'Playlists',
        'category': 'Deep Focus',
        'subtitle': 'Zero distractions, pure productivity.',
        'imageUrl': 'assets/images/focus.jpg',
      },
      {
        'id': 'deep_zone',
        'name': 'Deep Zone',
        'type': 'Playlists',
        'category': 'Deep Focus',
        'subtitle': 'Ambient soundscapes to lock you in.',
        'imageUrl': 'assets/images/deepzone.jpg',
      },
      {
        'id': 'night_drift',
        'name': 'Night Drift',
        'type': 'Playlists',
        'category': 'Midnight Walk',
        'subtitle': 'Empty streets and midnight thoughts.',
        'imageUrl': 'assets/images/nightdrift.jpg',
      },
      {
        'id': 'starlight',
        'name': 'Starlight',
        'type': 'Playlists',
        'category': 'Midnight Walk',
        'subtitle': 'Soundtrack for your late-night strolls.',
        'imageUrl': 'assets/images/starlight.jpg',
      },
      {
        'id': 'after_hours',
        'name': 'After Hours',
        'type': 'Playlists',
        'category': 'Midnight Walk',
        'subtitle': 'Neon lights and quiet beats.',
        'imageUrl': 'assets/images/afterhours.jpg',
      },
      {
        'id': 'power_rush',
        'name': 'Power Rush',
        'type': 'Playlists',
        'category': 'Workout Boost',
        'subtitle': 'High energy to crush your limits.',
        'imageUrl': 'assets/images/powerrush.jpg',
      },
      {
        'id': 'beast_mode',
        'name': 'Beast Mode',
        'isPinned': true,
        'type': 'Playlists',
        'category': 'Workout Boost',
        'subtitle': 'Heavy bass to fuel the grind.',
        'imageUrl': 'assets/images/beastmode.jpg',
      },
      {
        'id': 'hype_mix',
        'name': 'Hype Mix',
        'type': 'Playlists',
        'category': 'Workout Boost',
        'subtitle': 'Upbeat tracks for maximum drive.',
        'imageUrl': 'assets/images/hypemix.jpg',
      },
      {
        'id': 'blue_hour',
        'name': 'Blue Hour',
        'type': 'Playlists',
        'category': 'Melancholy',
        'subtitle': 'Soft melodies for heavy feelings.',
        'imageUrl': 'assets/images/bluehour.jpg',
      },
      {
        'id': 'soft_fade',
        'name': 'Soft Fade',
        'type': 'Playlists',
        'category': 'Melancholy',
        'subtitle': 'Gentle notes for quiet heartbreak.',
        'imageUrl': 'assets/images/softfade.jpg',
      },
      {
        'id': 'melancholy',
        'name': 'Melancholy',
        'type': 'Playlists',
        'category': 'Melancholy',
        'subtitle': 'Raw, honest songs that understand.',
        'imageUrl': 'assets/images/melancholy.jpg',
      },
      {
        'id': 'trending_now',
        'name': 'Trending Now',
        'type': 'Playlists',
        'category': 'Trending Spotlight',
        'subtitle': 'What the world is listening to today.',
        'imageUrl': 'assets/images/trending.jpg',
      },
      {
        'id': 'top_hits_id',
        'name': 'Top Hits Indonesia',
        'isPinned': true,
        'type': 'Playlists',
        'category': 'Trending Spotlight',
        'subtitle': 'Lagu terpopuler minggu ini.',
        'imageUrl': 'assets/images/tophits.jpg',
      },
      {
        'id': 'chart_climbers',
        'name': 'Chart Climbers',
        'type': 'Playlists',
        'category': 'Trending Spotlight',
        'subtitle': 'The biggest tracks blowing up right now.',
        'imageUrl': 'assets/images/chart.jpg',
      },
      {
        'id': 'hot_right_now',
        'name': 'Hot Right Now',
        'type': 'Playlists',
        'category': 'Trending Spotlight',
        'subtitle': 'Viral anthems you cannot skip.',
        'imageUrl': 'assets/images/hotright.jpg',
      },
      ..._playlistController.userPlaylists.map((p) {
        return {
          'type': 'Playlists',
          'category': 'Playlists',
          ...p,
        };
      }),
    ];

    // Mencegah duplikasi item berdasarkan nama playlist
    final Set<String> seenNames = {};
    List<Map<String, dynamic>> uniquePlaylists = [];

    for (var item in rawPlaylists) {
      final nameKey = item['name']?.toString().toLowerCase().trim() ?? '';
      if (nameKey.isNotEmpty && !seenNames.contains(nameKey)) {
        seenNames.add(nameKey);
        uniquePlaylists.add(item);
      }
    }

    // Filtering
    List<Map<String, dynamic>> filteredList = uniquePlaylists.where((item) {
      final name = item['name'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      final matchesSearch = name.contains(query);

      if (selectedFilter.isEmpty || selectedFilter.toLowerCase() == 'all') {
        return matchesSearch;
      }

      final itemType = (item['type'] ?? '').toString().toLowerCase();
      final itemCategory = (item['category'] ?? '').toString().toLowerCase();
      final filterLower = selectedFilter.toLowerCase();

      final matchesFilter =
          itemType == filterLower || itemCategory == filterLower;

      return matchesSearch && matchesFilter;
    }).toList();

    // Sorting
    filteredList.sort((a, b) {
      if (a['isLikedSongs'] == true) return -1;
      if (b['isLikedSongs'] == true) return 1;

      // Pinned items
      final bool isPinnedA = a['isPinned'] == true;
      final bool isPinnedB = b['isPinned'] == true;

      if (isPinnedA && !isPinnedB) return -1;
      if (!isPinnedA && isPinnedB) return 1;

      // Sort pilihan user
      switch (_currentSort) {
        case 'alphabet':
          return (a['name'] as String).compareTo(b['name'] as String);
        case 'SongCount':
          final countA = (a['songs'] as List?)?.length ?? 0;
          final countB = (b['songs'] as List?)?.length ?? 0;
          return countB.compareTo(countA);
        case 'Latest':
        default:
          return 0;
      }
    });

    return filteredList;
  }

  // Untuk membuat playlist baru
  void showCreatePlaylistDialog() {
    final controller = TextEditingController(
      text: 'New Playlist #${_playlistController.userPlaylists.length + 1}',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF282828) : Colors.white;
    final dialogTextColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: dialogBg,
          title: Text(
            'Give your playlist a name',
            style: TextStyle(color: dialogTextColor, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: dialogTextColor),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey : Colors.grey.shade400,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  _playlistController.createNewPlaylist(text);
                }
                Navigator.pop(ctx);
              },
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Untuk ganti nama playlist
  void showEditPlaylistDialog(Map<String, dynamic> item) {
    final controller = TextEditingController(text: item['name']);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF282828) : Colors.white;
    final dialogTextColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: dialogBg,
          title: Text(
            'Edit playlist name',
            style: TextStyle(color: dialogTextColor, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: dialogTextColor),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey : Colors.grey.shade400,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  final oldName = item['name'];
                  _playlistController.renamePlaylist(oldName, text);
                }
                Navigator.pop(ctx);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Konfirmasi hapus playlist
  void showDeletePlaylistDialog(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF282828) : Colors.white;
    final dialogTextColor = isDark ? Colors.white : Colors.black87;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: dialogBg,
          title: Text(
            'Delete Playlist?',
            style: TextStyle(color: dialogTextColor, fontSize: 18),
          ),
          content: Text(
            'Are you sure want to delete "${item['name']}"?',
            style: TextStyle(
              color: isDark ? Colors.grey : Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                final playlistKey = item['id'] ?? item['name'];
                _playlistController.deletePlaylist(playlistKey);
                Navigator.pop(ctx);
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
        );
      },
    );
  }

  void togglePin(Map<String, dynamic> item) {
    final name = item['name'] as String?;
    if (name != null) {
      _playlistController.togglePin(name);
    }
  }

  // Bottom sheet opsi saat playlist ditekan lama (Long Press)
  void _showPlaylistOptionsMenu(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPinned = item['isPinned'] == true;
    final isLikedSongs = item['isLikedSongs'] == true;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF282828) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  item['name'] ?? 'Playlist Options',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(height: 1),
              
              // Option: Pin / Unpin
              ListTile(
                leading: Icon(
                  isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                title: Text(
                  isPinned ? 'Remove Pin' : 'Pin playlist',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  togglePin(item);
                },
              ),

              // Option: Edit Name (selain Liked Songs)
              if (!isLikedSongs)
                ListTile(
                  leading: Icon(
                    Icons.edit_outlined,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  title: Text(
                    'Edit name',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    showEditPlaylistDialog(item);
                  },
                ),

              // Option: Delete Playlist (selain Liked Songs)
              if (!isLikedSongs)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    'Delete playlist',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    showDeletePlaylistDialog(item);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Custom Grid layout 2 kolom bertipe staggred / masonry
  Widget _buildCustomMasonryGrid(
    List<Map<String, dynamic>> displayList,
    bool isDark,
    Color textColor,
  ) {
    List<Widget> items = [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: InkWell(
            onTap: showCreatePlaylistDialog,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 48, color: textColor),
                  const SizedBox(height: 8),
                  Text(
                    'Add Playlist',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      ...displayList.map((item) {
        final String? imageUrl = item['imageUrl'];
        final bool hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistDetailScreen(playlist: item),
              ),
            );
          },
          onLongPress: () {
            _showPlaylistOptionsMenu(item);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E).withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: hasValidImage
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    image: DecorationImage(
                                      image: imageUrl.startsWith('http')
                                          ? NetworkImage(imageUrl)
                                              as ImageProvider
                                          : AssetImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF282828),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.music_note_rounded,
                                      color: Colors.grey,
                                      size: 48,
                                    ),
                                  ),
                                ),
                        ),
                        if (item['isPinned'] == true)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.push_pin,
                                    color: Color(0xFF1DB954),
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item['subtitle'] != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                item['subtitle'],
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ];

    // Membagi widget ke kolom kiri dan kanan bergantian
    List<Widget> leftColumnItems = [];
    List<Widget> rightColumnItems = [];

    for (int i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        leftColumnItems.add(items[i]);
        leftColumnItems.add(const SizedBox(height: 16));
      } else {
        rightColumnItems.add(items[i]);
        rightColumnItems.add(const SizedBox(height: 16));
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: leftColumnItems,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rightColumnItems,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = sortedPlaylists;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: LibraryHeader(
        onAddPressed: showCreatePlaylistDialog,
        isSearching: isSearching,
        onSearchToggle: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              searchQuery = '';
            }
          });
        },
        onSearchChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme
              .apply(bodyColor: textColor, displayColor: textColor),
          iconTheme: IconThemeData(color: textColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris filter chip dan dropdown sorting / layout toggle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FilterChipRow(
                      selectedFilter: selectedFilter,
                      onFilterSelected: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  LibrarySortDropdown(
                    selectedSort: _currentSort,
                    isGridView: _isGridView,
                    onSortChanged: (newSort) {
                      setState(() {
                        _currentSort = newSort;
                      });
                    },
                    onToggleLayout: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Tampilan utama playlist (Grid atau List view)
            Expanded(
              child: _isGridView
                  ? _buildCustomMasonryGrid(displayList, isDark, textColor)
                  : ListView.builder(
                      itemCount: displayList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return AddPlaylistButton(
                            onTap: showCreatePlaylistDialog,
                          );
                        }
                        final item = displayList[index - 1];
                        return PlaylistItemTile(
                          title: item['name'],
                          imageUrl: item['imageUrl'],
                          isPinned: item['isPinned'] ?? false,
                          onTogglePin: () => togglePin(item),
                          onEdit: () => showEditPlaylistDialog(item),
                          onDelete: () => showDeletePlaylistDialog(item),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlaylistDetailScreen(playlist: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}