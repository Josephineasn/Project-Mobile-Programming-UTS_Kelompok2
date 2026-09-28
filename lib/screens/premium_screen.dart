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
            // header foto
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

            // tulisan di header dan tombol premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // logo + teks "Premium"
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

                  // headline Besar
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

                  // tombol "Get Premium Standard"
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

                  const PremiumBenefitsCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // cover album di header
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