import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class HorizontalPlaylistSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const HorizontalPlaylistSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Bagian
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Daftar Geser Horizontal
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Cover Persegi
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (item['imageUrl'] ?? '').startsWith('assets/')
                          ? Image.asset(
                              item['imageUrl'] ?? '',
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              item['imageUrl'] ?? '',
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 8),

                    // Judul Album / Playlist
                    Text(
                      item['title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Deskripsi atau Nama Artis
                    Text(
                      item['subtitle'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}