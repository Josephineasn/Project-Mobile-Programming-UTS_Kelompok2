import 'package:flutter/material.dart';
import '../../models/song_model.dart';
import '../../services/audio_controller.dart';
import '../../services/playlist_controller.dart';

class SongTitleArtist extends StatelessWidget {
  final SongModel song;

  const SongTitleArtist({super.key, required this.song});

  void _showAddToPlaylistBottomSheet(BuildContext context) {
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
          listenable: playlistController,
          builder: (context, _) {
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
                        
                        final isAlreadyAdded = songs.any((s) => s.title == song.title);

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
                                  'Already added',
                                  style: TextStyle(color: Colors.grey, fontSize: 11),
                                )
                              : null,
                          onTap: isAlreadyAdded
                              ? null 
                              : () {
                                  playlistController.addSongToPlaylist(playlist['name'], song);
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added "${song.title}" to ${playlist['name']}',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
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
    final isLiked = audioController.isLiked(song);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song.title,
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
                song.artist,
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
                Icons.add_circle_outline,
                color: isDark ? Colors.grey.shade400 : Colors.black54,
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
              onPressed: () => audioController.toggleLike(song),
            ),
          ],
        ),
      ],
    );
  }
}