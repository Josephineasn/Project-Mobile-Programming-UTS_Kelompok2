import 'package:flutter/material.dart';

class PremiumComparisonTable extends StatelessWidget {
  const PremiumComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBgColor = isDark ? const Color(0xFF161922) : Colors.white;
    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final titleTextColor = isDark ? Colors.white : const Color(0xFF15181E);
    final subtextColor = isDark ? Colors.white60 : const Color(0xFF6B7280);

    final comparisonItems = [
      {'feature': 'On-demand Playback (No forced shuffle)', 'free': false, 'premium': true},
      {'feature': 'Studio Audio Quality (~320kbps)', 'free': false, 'premium': true},
      {'feature': 'Unlimited Song Skips', 'free': false, 'premium': true},
      {'feature': 'Access to Full Music Library', 'free': true, 'premium': true},
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
            color: isDark
                ? Colors.black.withValues(alpha: 0.45)
                : const Color(0xFFA0AEC0).withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free vs Premium',
            style: TextStyle(
              color: titleTextColor,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'See what you unlock with a subscription',
            style: TextStyle(
              color: subtextColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Header kolom
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'Features',
                    style: TextStyle(
                      color: subtextColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Free',
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Premium',
                      style: const TextStyle(
                        color: Color(0xFF1DB954),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
            height: 1,
          ),
          const SizedBox(height: 6),

          ...comparisonItems.map((item) {
            final featureName = item['feature'] as String;
            final isFree = item['free'] as bool;
            final isPremium = item['premium'] as bool;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 9.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      featureName,
                      style: TextStyle(
                        color: titleTextColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: isFree
                          ? Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: isDark ? Colors.white70 : Colors.black87,
                            )
                          : Icon(
                              Icons.remove_rounded,
                              size: 18,
                              color: isDark ? Colors.white24 : Colors.grey.shade400,
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: isPremium
                          ? const Icon(
                              Icons.check_circle_rounded,
                              size: 18,
                              color: Color(0xFF1DB954),
                            )
                          : const Icon(
                              Icons.remove_rounded,
                              size: 18,
                              color: Colors.grey,
                            ),
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