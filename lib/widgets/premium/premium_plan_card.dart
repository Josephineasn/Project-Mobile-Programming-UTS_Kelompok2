import 'package:flutter/material.dart';

// Container Iklan (Why join Premium Standard?)
class PremiumBenefitsCard extends StatelessWidget {
  const PremiumBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E212B), Color(0xFF161822)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0x26FFC107), 
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Why join Premium Standard?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0x0FFFFFFF), height: 1),

          // Benefits
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0x0DFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white70, size: 18),
          ),
          const SizedBox(width: 12),
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
  final String title;
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
        gradient: LinearGradient(
          colors: [
            titleColor.withAlpha(30),
            const Color(0xFF14161F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: titleColor.withAlpha(90),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header mini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.album_outlined,
                          color: titleColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: titleColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: titleColor, width: 1),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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

                const Divider(color: Color(0x14FFFFFF), height: 1),
                const SizedBox(height: 14),

                // List Fitur
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: titleColor.withAlpha(215),
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
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

                // Keterangan Terms Bawah
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