import 'package:flutter/material.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/settings_screen.dart';
import '../services/premium_controller.dart';
import '../widgets/premium/premium_comparison_table.dart';
import '../widgets/premium/premium_plan_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  void _showTermsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E212B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF15181E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Subscription access activates immediately once payment is verified.\n\n'
            '2. Completed payments are non-refundable.\n\n'
            '3. You can cancel your subscription plan renewal at any time directly in Settings.\n\n'
            '4. Smart offline storage and studio-grade acoustics remain fully functional throughout your billing period.',
            style: TextStyle(
              color: Colors.grey,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                      color: isDark ? Colors.white : const Color(0xFF15181E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: $price',
                    style: TextStyle(
                      color: isDark ? Colors.amber : const Color(0xFFD97706),
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Payment Method:',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF4B5563),
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
                              ? (isDark
                                  ? Colors.white.withValues(alpha: 0.12)
                                  : Colors.amber.withValues(alpha: 0.12))
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.04)
                                  : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isChosen
                                ? (isDark ? Colors.amber : const Color(0xFFD97706))
                                : (isDark ? Colors.white12 : Colors.grey.shade300),
                            width: isChosen ? 1.4 : 1.0,
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
                                  color: isDark ? Colors.white : const Color(0xFF15181E),
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
                              size: 19,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : const Color(0xFF15181E),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                        elevation: 0,
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
                      child: const Text('Pay Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
        margin: const EdgeInsets.symmetric(horizontal: 7),
        width: 118,
        height: 118,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: (elevation * 0.05).clamp(0.0, 1.0)),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: const Color(0xFF1E212B),
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
    final textColor = isDark ? Colors.white : const Color(0xFF15181E);
    final bgColor = theme.scaffoldBackgroundColor;

    return ValueListenableBuilder(
      valueListenable: currentAccountNotifier,
      builder: (context, activeAccount, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: PremiumController.isPremium,
          builder: (context, isGlobalPremium, _) {
            final isPremium = activeAccount.isPremium || isGlobalPremium;

            if (isPremium) {
              return Scaffold(
                backgroundColor: bgColor,
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1DB954).withValues(alpha: 0.16),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_rounded, color: Color(0xFF1DB954), size: 72),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'You are a Premium Member',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Unlimited skips, ad-free listening, and studio sound quality are fully active on this account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54,
                              fontSize: 13.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1DB954),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavScreen(initialIndex: 0),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'Back to Home',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

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
                              height: 255,
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
                                    stops: const [0.0, 0.45, 0.82, 1.0],
                                    colors: [
                                      Colors.transparent,
                                      bgColor.withValues(alpha: 0.45),
                                      bgColor.withValues(alpha: 0.92),
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
                                      color: const Color(0xFF1DB954).withValues(alpha: isDark ? 0.2 : 0.14),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.stars_rounded, color: Color(0xFF1DB954), size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Melodix Plus',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF1DB954) : const Color(0xFF15803D),
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Listen without limits\nwith Melodix Standard.',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  height: 1.18,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.15)
                                          : Colors.black.withValues(alpha: 0.18),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () => _showCheckoutDialog(
                                    context,
                                    'Standard',
                                    'IDR 59,900 / month',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark ? Colors.white : const Color(0xFF15181E),
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
                                    color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                                    fontSize: 11.5,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 26),
                              const PremiumBenefitsCard(),
                              const SizedBox(height: 26),
                              const PremiumComparisonTable(),
                              const SizedBox(height: 36),
                              Text(
                                'Available Plans',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 16),
                              PremiumPlanCard(
                                title: 'Standard',
                                titleColor: const Color(0xFF1DB954),
                                price: 'IDR 59,900 / month',
                                features: const [
                                  '1 Melodix Standard account with full track autonomy',
                                  'Download albums for seamless offline listening',
                                  'Studio-grade acoustic resolution (~320kbps)',
                                  'Continuous streaming with zero commercial breaks',
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
                                badgeText: 'Ultimate Studio',
                                title: 'Platinum',
                                titleColor: const Color.fromARGB(255, 255, 191, 71),
                                price: 'IDR 119,900 / month',
                                features: const [
                                  'Up to 3 high-definition listening profiles',
                                  'Hi-Res Lossless 24-bit audio format',
                                  'AI Smart Curator & tailored daily mix sessions',
                                  'Early access to exclusive tracks and live concerts',
                                  'Cancel your subscription anytime',
                                ],
                                buttonText: 'Get Platinum',
                                buttonColor: const Color.fromARGB(255, 255, 191, 71),
                                footerText: 'For up to 3 listeners residing in the same household.',
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).maybePop();
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.55)
                                : Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.black.withValues(alpha: 0.08),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isDark ? Colors.white : Colors.black87,
                            size: 16,
                          ),
                        ),
                      ),
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
}