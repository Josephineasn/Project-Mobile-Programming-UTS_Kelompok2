import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final String title;
  final String image;

  const SearchCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              height: 190,

              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),

                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              maxLines: 1,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
