import 'package:flutter/material.dart';

// Container Iklan (Why join Premium Standard?)
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
          const Divider(color: Color.fromARGB(15, 85, 78, 78), height: 1),

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

// Ukuran dan warna untuk icon dan teks
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

// Plans
class PremiumPlanCard extends StatelessWidget {
  final String? badgeText;
  final String title; // "Standard", "Platinum", "Student", "Family"
  final Color titleColor;
  final String price;
  final List<String> features;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final String? footerText;
  final VoidCallback onSelect;

  const PremiumPlanCard({
    super.key,
    this.badgeText,
    required this.title,
    required this.titleColor,
    required this.price,
    required this.features,
    required this.buttonText,
    required this.buttonColor,
    this.buttonTextColor = Colors.black,
    this.footerText,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header mini (logo dan tulisan "Premium")
                Row(
                  children: const [
                    Icon(
                      Icons.album_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Nama Paket
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Harga Paket
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 14),

                // Poin-poin
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tombol Paket
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Keterangan Terms Bawah (family, platinum)
                if (footerText != null) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      footerText!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}