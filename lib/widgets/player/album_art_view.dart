import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AlbumArtView extends StatelessWidget {
  final String? imageUrl;
  final double height;

  const AlbumArtView({
    super.key,
    this.imageUrl,
    this.height = 320.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Icon(
                Icons.music_note,
                size: 100,
                color: AppColors.primaryGreen,
              ),
            )
          : null,
    );
  }
}