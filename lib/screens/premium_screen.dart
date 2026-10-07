import 'package:flutter/material.dart';
import '../services/premium_controller.dart';
import '../widgets/premium/premium_plan_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  void _showTermsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E212B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. Subscription access activates immediately once payment is verified.\n\n'
            '2. Payments are non-refundable.\n\n'
            '3. You can cancel your subscription plan at any time in Settings.\n\n'
            '4. Offline listening and studio-quality audio remain active during the valid subscription period.',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, String planTitle, String price) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String selectedPayment = 'GoPay';
    final paymentMethods = [
      {'name': 'GoPay', 'icon': Icons.account_balance_wallet_outlined},
      {'name': 'DANA', 'icon': Icons.wallet_outlined},
      {'name': 'OVO', 'icon': Icons.payments_outlined},
      {'name': 'Bank Transfer (BCA/Mandiri)', 'icon': Icons.account_balance_outlined},
      {'name': 'Credit / Debit Card', 'icon': Icons.credit_card_outlined},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E212B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscribe to $planTitle',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: $price',
                    style: TextStyle(
                      color: isDark ? Colors.amber : const Color(0xFFB45309),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Payment Method:',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...paymentMethods.map((pm) {
                    final name = pm['name'] as String;
                    final icon = pm['icon'] as IconData;
                    final isChosen = selectedPayment == name;
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selectedPayment = name;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isChosen
                              ? (isDark ? Colors.white.withAlpha(25) : Colors.amber.withAlpha(35))
                              : (isDark ? Colors.white.withAlpha(10) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isChosen
                                ? (isDark ? Colors.amber : const Color(0xFFD97706))
                                : (isDark ? Colors.white12 : Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              color: isChosen
                                  ? (isDark ? Colors.amber : const Color(0xFFD97706))
                                  : (isDark ? Colors.white70 : Colors.black54),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontSize: 13,
                                  fontWeight: isChosen ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              isChosen ? Icons.check_circle_rounded : Icons.radio_button_off,
                              color: isChosen
                                  ? (isDark ? Colors.amber : const Color(0xFFD97706))
                                  : (isDark ? Colors.white30 : Colors.black26),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.black87,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {
                        PremiumController.activatePremium(planTitle);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.amber,
                            content: Text(
                              'Successfully subscribed to $planTitle via $selectedPayment!',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAlbumTile(String url, double angle, double elevation) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 116,
        height: 116,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((elevation * 20).toInt().clamp(0, 255)),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade900,
              child: const Icon(Icons.music_note_rounded, color: Colors.white54, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: OverflowBox(
                        maxWidth: MediaQuery.of(context).size.width * 1.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAlbumTile('https://i.pinimg.com/1200x/55/ed/d5/55edd5f8215e3e6ae9d842501ddeb296.jpg', -0.12, 4),
                            _buildAlbumTile('https://i.pinimg.com/1200x/40/e0/51/40e051803c96da23aa787e846532f6a4.jpg', -0.04, 6),
                            _buildAlbumTile('https://i.pinimg.com/1200x/62/cd/f5/62cdf5877dfa0115900fcc5ca0551368.jpg', 0.05, 8),
                            _buildAlbumTile('https://i.pinimg.com/736x/28/60/7a/28607abee735a5c7ab04d1eb42a20aab.jpg', -0.08, 6),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.4, 0.8, 1.0],
                            colors: [
                              Colors.transparent,
                              bgColor.withAlpha(130),
                              bgColor.withAlpha(235),
                              bgColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1DB954).withAlpha(isDark ? 45 : 30),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.stars_rounded, color: Color(0xFF1DB954), size: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Melodix Plus',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Listen without limits\nwith Melodix Standard.',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _showCheckoutDialog(
                            context,
                            'Standard',
                            'IDR 59,900 / month',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? Colors.white : Colors.black87,
                            foregroundColor: isDark ? Colors.black : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Get Melodix Standard',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => _showTermsDialog(context),
                        child: Text(
                          'Terms & conditions apply.',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 11.5,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const PremiumBenefitsCard(),
                      const SizedBox(height: 34),
                      Text(
                        'Available Plans',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PremiumPlanCard(
                        title: 'Standard',
                        titleColor: const Color(0xFF1DB954),
                        price: 'IDR 59,900 / month',
                        features: const [
                          '1 Melodix Standard Account',
                          'Download music for offline listening',
                          'Studio-grade audio format (~320kbps)',
                          'Continuous music with no commercial ad breaks',
                          'Cancel your subscription anytime',
                        ],
                        buttonText: 'Get Standard',
                        buttonColor: const Color(0xFF1DB954),
                        onSelect: () => _showCheckoutDialog(
                          context,
                          'Standard',
                          'IDR 59,900 / month',
                        ),
                      ),
                      PremiumPlanCard(
                        title: 'Platinum',
                        titleColor: const Color.fromARGB(255, 255, 191, 71),
                        price: 'IDR 119,900 / month',
                        features: const [
                          'High-fidelity lossless audio (320 kbps)',
                          'AI Smart Curator & Personalized Recommendations',
                          'Exclusive releases & early song access',
                          'Cancel your subscription anytime',
                        ],
                        buttonText: 'Get Platinum',
                        buttonColor: const Color.fromARGB(255, 255, 191, 71),
                        onSelect: () => _showCheckoutDialog(
                          context,
                          'Platinum',
                          'IDR 119,900 / month',
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Back Button Navigation 
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}