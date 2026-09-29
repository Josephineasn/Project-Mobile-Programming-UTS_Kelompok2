import 'package:flutter/material.dart';
import '../widgets/premium/premium_plan_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header foto
            Stack(
              children: [
                SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: OverflowBox(
                    maxWidth: MediaQuery.of(context).size.width * 1.35,
                    child: Transform.rotate(
                      angle: -0.14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAlbumTile('https://picsum.photos/seed/phonk/250'),
                          _buildAlbumTile('https://picsum.photos/seed/friday/250'),
                          _buildAlbumTile('https://picsum.photos/seed/house/250'),
                          _buildAlbumTile('https://picsum.photos/seed/reggae/250'),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.45, 0.85, 1.0],
                        colors: [
                          Colors.transparent,
                          Color(0x99121212),
                          Color(0xF5121212),
                          Color(0xFF121212),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Tulisan di header dan tombol premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + teks "Premium"
                  Row(
                    children: const [
                      Icon(Icons.album_outlined, color: Colors.white, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Headline Besar
                  const Text(
                    'Get more out of your\nmusic with Premium\nStandard.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Tombol "Get Premium Standard"
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Premium Standard',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Syarat & Ketentuan
                  const Text(
                    'Terms apply.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'See other plans below.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 28),

                  // Kotak Why join Premium Standard?
                  const PremiumBenefitsCard(),
                  const SizedBox(height: 36),

                  // Available plans
                  const Text(
                    'Available plans',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Paket 1: Standard
                  PremiumPlanCard(
                    title: 'Standard',
                    titleColor: const Color(0xFF1DB954),
                    price: 'IDR 59,900 / month',
                    features: const [
                      '1 Standard account',
                      'Download to listen offline',
                      'Very high audio quality (up to ~320kbps)',
                      'Cancel anytime',
                    ],
                    buttonText: 'Get Premium Standard',
                    buttonColor: const Color(0xFF1DB954),
                    onSelect: () {},
                  ),

                  // Paket 2: Platinum
                  PremiumPlanCard(
                    title: 'Platinum',
                    titleColor: const Color(0xFFE8FD52),
                    price: 'IDR 119,900 / month',
                    features: const [
                      'Up to 3 Platinum accounts',
                      'Download to listen offline',
                      'Lossless audio quality (up to ~24-bit/\n44.1kHz)',
                      'Mix your playlists',
                      'Your personal AI DJ',
                      'AI playlist creation',
                      'Connect your DJ software',
                      'Cancel anytime',
                    ],
                    buttonText: 'Get Premium Platinum',
                    buttonColor: const Color(0xFFE8FD52),
                    footerText: 'For up to 3 individuals residing at the same address. Terms apply.',
                    onSelect: () {},
                  ),

                  // Paket 3: Student
                  PremiumPlanCard(
                    badgeText: 'Savings available',
                    title: 'Student',
                    titleColor: const Color(0xFF7AE7A7),
                    price: 'IDR 29,900 / month',
                    features: const [
                      '1 verified Standard account',
                      'Download to listen offline',
                      'Very high audio quality (up to ~320kbps)',
                      'Cancel anytime',
                    ],
                    buttonText: 'Get Premium Student',
                    buttonColor: const Color(0xFF1DB954),
                    onSelect: () {},
                  ),

                  // Paket 4: Family
                  PremiumPlanCard(
                    title: 'Family',
                    titleColor: const Color(0xFF579FF4),
                    price: 'IDR 86,900 / month',
                    features: const [
                      'Up to 6 Premium accounts',
                      'Block explicit music',
                      'Download to listen offline',
                      'Cancel anytime',
                    ],
                    buttonText: 'Get Premium Family',
                    buttonColor: const Color(0xFF579FF4),
                    footerText: 'For up to 6 family members living under one roof. Terms apply.',
                    onSelect: () {},
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cover album di header
  Widget _buildAlbumTile(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}