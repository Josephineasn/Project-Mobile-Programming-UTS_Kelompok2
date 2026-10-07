import 'package:flutter/material.dart';

// Kotak Benefit
class PremiumBenefitsCard extends StatelessWidget {
  const PremiumBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? const Color(0xFF171A24) : Colors.white;
    final cardBorderColor = isDark ? Colors.white.withAlpha(20) : Colors.grey.shade200;
    final titleTextColor = isDark ? Colors.white : const Color(0xFF191B22);
    final subtitleTextColor = isDark ? Colors.white60 : Colors.black54;

    final benefitItems = [
      {
        'title': 'Bebas Jeda Iklan',
        'desc': 'Musik mengalir terus tanpa jeda audio sponsor komersial.',
        'icon': Icons.all_inclusive_rounded,
        'color': const Color(0xFF1DB954),
      },
      {
        'title': 'Kendali Trek Penuh',
        'desc': 'Bebas pilih dan putar lagu mana saja tanpa sistem acak paksa.',
        'icon': Icons.tune_rounded,
        'color': const Color(0xFF579FF4),
      },
      {
        'title': 'Kualitas Studio Master',
        'desc': 'Vokal lebih tebal dan bass lebih bulat di headphone kesayanganmu.',
        'icon': Icons.graphic_eq_rounded,
        'color': const Color(0xFFC084FC),
      },
      {
        'title': 'Mode Offline Cerdas',
        'desc': 'Simpan playlist ke memori lokal, tetap asyik walau tanpa kuota.',
        'icon': Icons.download_done_rounded,
        'color': const Color(0xFFFBBF24),
      },
      {
        'title': 'Sesi Dengar Bersama',
        'desc': 'Putar lagu bareng teman secara sinkron dan real-time.',
        'icon': Icons.group_rounded,
        'color': const Color(0xFFFF758F),
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.grey.shade300.withAlpha(120),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.amber.withAlpha(isDark ? 45 : 35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keuntungan Eksklusif Melodix',
                      style: TextStyle(
                        color: titleTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rasakan pengalaman audio terbaik setiap hari',
                      style: TextStyle(
                        color: subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white12 : Colors.grey.shade200, height: 1),
          const SizedBox(height: 14),

          // Daftar Benefit
          ...benefitItems.map((item) {
            final iconColor = item['color'] as Color;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(isDark ? 35 : 25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: iconColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            color: titleTextColor,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['desc'] as String,
                          style: TextStyle(
                            color: subtitleTextColor,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Paket Langganan Premium
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? const Color(0xFF151821) : Colors.white;
    final cardBorderColor = isDark ? titleColor.withAlpha(90) : titleColor.withAlpha(140);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF191B22);
    final featureTextColor = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final footerColor = isDark ? Colors.white38 : Colors.black45;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cardBorderColor,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: titleColor.withAlpha(isDark ? 30 : 35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Gradasi Aksen Paket
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: titleColor.withAlpha(isDark ? 35 : 25),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.album_outlined, color: titleColor, size: 17),
                    const SizedBox(width: 6),
                    Text(
                      'MELODIX PLAN',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: titleColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText!,
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  price,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                Divider(color: dividerColor, height: 1),
                const SizedBox(height: 14),

                // Daftar Fitur
                ...features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: titleColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: featureTextColor,
                              fontSize: 13,
                              height: 1.35,
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

                if (footerText != null) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      footerText!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: footerColor,
                        fontSize: 10.5,
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