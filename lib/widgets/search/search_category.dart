import 'package:flutter/material.dart';

class SearchCategory extends StatelessWidget {
  final String title;
  final Color color;
  final String? imageUrl;
  final VoidCallback onTap;

  const SearchCategory({
    super.key,
    required this.title,
    required this.color,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 112,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Image.network(
                  imageUrl!,
                  width: 104,
                  height: 104,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.05)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.3, 1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
