import 'package:flutter/material.dart';
import '../../models/song_model.dart';
import '../../services/audio_controller.dart';
import '../../services/playlist_controller.dart';

class SongTitleArtist extends StatelessWidget {
  final SongModel song;

  const SongTitleArtist({super.key, required this.song});

  void _showAddToPlaylistBottomSheet(BuildContext context) {
    final audioController = AudioController.instance;
    final playlistController = PlaylistController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF282828) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListenableBuilder(
          listenable: Listenable.merge([audioController, playlistController]),
          builder: (context, _) {
            final activeSong = audioController.currentSong ?? song;
            final playlists = playlistController.userPlaylists;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add to Playlist',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        final List<SongModel> songs =
                            List<SongModel>.from(playlist['songs'] ?? []);

                        final isAlreadyAdded = songs.any(
                          (s) => s.title.trim().toLowerCase() == activeSong.title.trim().toLowerCase(),
                        );

                        return ListTile(
                          leading: Icon(
                            isAlreadyAdded ? Icons.check_circle : Icons.playlist_add,
                            color: isAlreadyAdded ? const Color(0xFF1DB954) : Colors.grey,
                          ),
                          title: Text(
                            playlist['name'],
                            style: TextStyle(
                              color: isAlreadyAdded
                                  ? const Color(0xFF1DB954)
                                  : (isDark ? Colors.white : Colors.black87),
                              fontWeight: isAlreadyAdded ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: isAlreadyAdded
                              ? const Text(
                                  'Already added • Tap to remove',
                                  style: TextStyle(color: Colors.grey, fontSize: 11),
                                )
                              : null,
                          onTap: () {
                            if (isAlreadyAdded) {
                              playlistController.removeSongFromPlaylist(playlist['name'], activeSong);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Removed "${activeSong.title}" from ${playlist['name']}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              playlistController.addSongToPlaylist(playlist['name'], activeSong);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added "${activeSong.title}" to ${playlist['name']}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioController = AudioController.instance;
    final playlistController = PlaylistController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: Listenable.merge([audioController, playlistController]),
      builder: (context, _) {
        final activeSong = audioController.currentSong ?? song;
        final isLiked = audioController.isLiked(activeSong);

        final bool isAddedToAnyPlaylist = playlistController.userPlaylists.any((playlist) {
          final List<SongModel> songs = List<SongModel>.from(playlist['songs'] ?? []);
          return songs.any((s) => s.title.trim().toLowerCase() == activeSong.title.trim().toLowerCase());
        });

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activeSong.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activeSong.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isAddedToAnyPlaylist
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                    color: isAddedToAnyPlaylist
                        ? const Color(0xFF1DB954)
                        : (isDark ? Colors.grey.shade400 : Colors.black54),
                    size: 26,
                  ),
                  onPressed: () => _showAddToPlaylistBottomSheet(context),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? const Color(0xFF1DB954) : Colors.white,
                    size: 26,
                  ),
                  onPressed: () => audioController.toggleLike(activeSong),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}