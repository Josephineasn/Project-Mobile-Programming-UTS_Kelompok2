import 'dart:ui';
import 'package:flutter/material.dart';

class PlaylistItemTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const PlaylistItemTile({
    super.key,
    required this.title,
    this.imageUrl,
    required this.isPinned,
    required this.onTogglePin,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  Widget _buildImage(bool isDark) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
        child: Icon(
          Icons.music_note,
          color: isDark ? Colors.grey : Colors.grey.shade700,
          size: 28,
        ),
      );
    }

    if (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://')) {
      return Image.network(
        imageUrl!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 50,
          height: 50,
          color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
          child: Icon(
            Icons.music_note,
            color: isDark ? Colors.grey : Colors.grey.shade700,
            size: 28,
          ),
        ),
      );
    }

    return Image.asset(
      imageUrl!,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 50,
        height: 50,
        color: isDark ? const Color(0xFF282828) : Colors.grey.shade300,
        child: Icon(
          Icons.music_note,
          color: isDark ? Colors.grey : Colors.grey.shade700,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDark
                        ? [
                            const Color(0xFF2A2A2A).withAlpha(220),
                            const Color(0xFF1E1E1E).withAlpha(200),
                          ]
                        : [
                            Colors.white,
                            const Color(0xFFDCDFE3).withAlpha(220),
                          ],
                  ),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withAlpha(35)
                        : Colors.white.withAlpha(200),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 40 : 15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: _buildImage(isDark),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isPinned) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1DB954)
                                        .withAlpha(40),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.push_pin,
                                    color: Color(0xFF1DB954),
                                    size: 11,
                                  ),
                                ),
                              ],
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: titleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Playlist • Kelompok 2',
                            style: TextStyle(color: subColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert_rounded, color: subColor),
                      color: isDark ? const Color(0xFF282828) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'pin') {
                          onTogglePin();
                        } else if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'pin',
                          child: Row(
                            children: [
                              Icon(
                                isPinned
                                    ? Icons.push_pin_outlined
                                    : Icons.push_pin,
                                size: 18,
                                color: titleColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isPinned ? 'Remove Pin' : 'Pin Playlist',
                                style: TextStyle(color: titleColor),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: titleColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Edit Name',
                                style: TextStyle(color: titleColor),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
