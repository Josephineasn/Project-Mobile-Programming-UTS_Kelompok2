import 'package:flutter/material.dart';

class PremiumBenefitsCard extends StatelessWidget {
  const PremiumBenefitsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? const Color(0xFF161922) : Colors.white;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF15181E);
    final subtitleTextColor = isDark ? Colors.white60 : const Color(0xFF6B7280);

    final benefitItems = [
      {
        'title': 'Uninterrupted Music Flow',
        'desc': 'Zero commercial disruptions from the first beat to the outro.',
        'icon': Icons.all_inclusive_rounded,
        'color': const Color(0xFF1DB954),
      },
      {
        'title': 'Full Track Autonomy',
        'desc': 'Play, loop, or skip any track on demand without forced shuffles.',
        'icon': Icons.tune_rounded,
        'color': const Color(0xFF579FF4),
      },
      {
        'title': 'Studio Master Clarity',
        'desc': 'Uncompressed vocal presence and deep bass tuned for your headphones.',
        'icon': Icons.graphic_eq_rounded,
        'color': const Color(0xFFC084FC),
      },
      {
        'title': 'Smart Offline Storage',
        'desc': 'Download full albums to device storage and listen anywhere without data.',
        'icon': Icons.download_done_rounded,
        'color': const Color(0xFFFBBF24),
      },
      {
        'title': 'Real-Time Friend Sessions',
        'desc': 'Host synced listening rooms with friends wherever they are.',
        'icon': Icons.group_rounded,
        'color': const Color(0xFFFF758F),
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0xFFA0AEC0).withValues(alpha: 0.18),
            blurRadius: 20,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: isDark ? 0.16 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exclusive Melodix Perks',
                      style: TextStyle(
                        color: titleTextColor,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pure listening pleasure built into every track',
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
          Divider(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 14),

          // Benefit feature list
          ...benefitItems.map((item) {
            final iconColor = item['color'] as Color;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: isDark ? 0.16 : 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: iconColor,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 13),
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

// Polished Plan Card
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
    final cardBorderColor = isDark
        ? titleColor.withValues(alpha: 0.35)
        : titleColor.withValues(alpha: 0.5);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF14171F);
    final featureTextColor = isDark ? Colors.white70 : const Color(0xFF374151);
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final footerColor = isDark ? Colors.white38 : const Color(0xFF9CA3AF);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: cardBorderColor,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: titleColor.withValues(alpha: isDark ? 0.14 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: titleColor.withValues(alpha: isDark ? 0.15 : 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.album_outlined, color: titleColor, size: 17),
                    const SizedBox(width: 7),
                    Text(
                      'MELODIX PLAN',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
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
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleTextColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
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
                        const SizedBox(width: 10),
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

                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withValues(alpha: isDark ? 0.35 : 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                if (footerText != null) ...[
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      footerText!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: footerColor,
                        fontSize: 11,
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