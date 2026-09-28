import 'package:flutter/material.dart';

// Container Iklan
class PremiumBenefitsCard extends StatelessWidget {
  const PremiumBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Why join Premium Standard?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // Benefits
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: const [
                PremiumFeatureItem(
                  icon: Icons.speaker_notes_off_outlined,
                  title: 'Ad-free music listening',
                ),
                PremiumFeatureItem(
                  icon: Icons.shuffle,
                  title: 'Play songs in any order',
                ),
                PremiumFeatureItem(
                  icon: Icons.headphones_outlined,
                  title: 'Very high audio quality',
                ),
                PremiumFeatureItem(
                  icon: Icons.group_outlined,
                  title: 'Listen with friends in real time',
                ),
                PremiumFeatureItem(
                  icon: Icons.smart_display_outlined,
                  title: 'Watch videos with fewer ads',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ukuran dan warna icon dan teks
class PremiumFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const PremiumFeatureItem({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}