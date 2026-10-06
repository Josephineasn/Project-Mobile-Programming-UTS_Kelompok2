import 'package:flutter/material.dart';

import '../services/audio_controller.dart';
import '../widgets/library/playlist_item_tile.dart';
import '../widgets/library/library_header.dart';
import '../widgets/library/filter_chip_row.dart';
import '../widgets/library/add_playlist_button.dart';
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

  String selectedFilter = '';
  bool isSearching = false;
  String searchQuery = '';

  String _currentSort = 'terbaru';
  bool _isGridView = false;

  late List<Map<String, dynamic>> playlists;

  @override
  void initState() {
    super.initState();
    _audioController.addListener(_onAudioChanged);

    playlists = [
      {
        'name': 'Liked Songs',
        'isPinned': true,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/liked_songs.png',
      },
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
        'subtitle': 'Hopeless Romantic Love music for you. Also try soft pop,easy listening,indie,bollywood,singer-songwriter',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/hopeless-romantic.jpg',
      },
      {
        'name': 'Yearning Mix',
        'subtitle': 'Yearning music for you. Also try soft pop,indie,alternative,singeer-songwriter,harana',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/yearning.jpg',
      },
      {
        'name': 'Delulu Mix',
        'subtitle': 'Delulu music for you. Also try opm,harana,kundiman,bollywood,pinoy indie',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/delulu.jpg',
      },
      {
        'name': 'Gentle Love Mix',
        'subtitle': 'Gentle Love music for you. Also try singer-songwriter, indie pop,italo disco,easy listening,new wave',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/gentle-love.jpg',
      },
      {
        'name': 'Situationship Mix',
        'subtitle': 'Situationship for you. Also try pop, singer-songwriter,slowcore,indie,alternative',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/situationship.jpg',
      },
      {
        'name': 'Crying Sad Mix',
        'subtitle': 'Crying Sad Music for you. Also try pop,slowcore,indie,singer-songwriter,latin',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/crying-sad.jpg',
      },
      {
        'name': 'Moody Sad Mix',
        'subtitle': 'Moody Sad music for you.Also try pop,slowcore,easy listening,singer-songwriter,latin',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/moody-sad.jpg',
      },
      {
        'name': 'Masterpiece Mix',
        'subtitle': 'Masterpiece music for you.Also try hindi pop,bollywood,indian indie,indorock,indonesian rock',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/masterpiece.jpg',
      },
      {
        'name': 'Comforting Mix',
        'subtitle': 'Comforting music for you. Also try slowcore,indie,soft pop,singer-songwriter,harana',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/comforting.jpg',
      },
      {
        'name': 'Fomo Mix',
        'subtitle': 'Fomo music for you.Also try indie,pop,indorock,alternative,indonesian jazz',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/fomo.jpg',
      },
      {
        'name': 'Main Character Mix',
        'subtitle': 'Main Character music for you.Also try pop,tollywood,alternative,indie,dance',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/main-character.jpg',
      },
      {
        'name': 'Rizz Mix',
        'subtitle': 'Rizz music for you.Also try r&b,childrens music,disco,bisrock,hyperpop',
        'isPinned': false,
        'songs': <SongModel>[],
        'imageUrl': 'assets/images/rizz.jpg',
      },
    ];
  }

  @override
  void dispose() {
    _audioController.removeListener(_onAudioChanged);
    super.dispose();
  }

  void _onAudioChanged() {
    if (mounted) {
      setState(() {
        final likedIndex = playlists.indexWhere(
          (p) => p['name'] == 'Liked Songs',
        );
        if (likedIndex != -1) {
          playlists[likedIndex]['songs'] = List<SongModel>.from(_audioController.likedSongs);
        }
      });
    }
  }

  List<Map<String, dynamic>> get sortedPlaylists {
    List<Map<String, dynamic>> filteredList = playlists.where((item) {
      final name = item['name'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();

    filteredList.sort((a, b) {
      // Pinned selalu di atas
      if (a['isPinned'] != b['isPinned']) {
        return a['isPinned'] ? -1 : 1;
      }
      // Urutkan berdasarkan opsi dropdown jika status pinned-nya sama
      switch (_currentSort) {
        case 'Latest':
          return 0;
        case 'alphabet':
          return (a['name'] as String).compareTo(b['name'] as String);
        case 'SongCount':
          final countA = (a['songs'] as List?)?.length ?? 0;
          final countB = (b['songs'] as List?)?.length ?? 0;
          return countB.compareTo(countA);
        default:
          return 0;
      }
    });

    return filteredList;
  }

  // Tambah Playlist
  void showCreatePlaylistDialog() {
    final controller = TextEditingController(
      text: 'New Playlist #${playlists.length + 1}',
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
                  setState(() {
                    playlists.add({
                      'name': text,
                      'isPinned': false,
                      'songs': <SongModel>[],
                    });
                  });
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

  // Edit Nama Playlist
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
                  setState(() {
                    item['name'] = text;
                  });
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

  // Konfirmasi Hapus Playlist
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
                setState(() {
                  playlists.remove(item);
                });
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
    setState(() {
      item['isPinned'] = !item['isPinned'];
    });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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

            Expanded(
              child: _isGridView
                  ? GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        String imageUrl =
                            item['imageUrl'] ?? 'assets/images/placeholder.jpg';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlaylistDetailScreen(playlist: item),
                              ),
                            );
                          },
                          onLongPress: () {
                            showEditPlaylistDialog(item);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: imageUrl.startsWith('http')
                                              ? NetworkImage(imageUrl)
                                                    as ImageProvider
                                              : AssetImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (item['isPinned'] == true)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.push_pin,
                                            color: Color(0xFF1DB954),
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (item['subtitle'] != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item['subtitle'],
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        return PlaylistItemTile(
                          title: item['name'],
                          imageUrl: item['imageUrl'],
                          isPinned: item['isPinned'],
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
