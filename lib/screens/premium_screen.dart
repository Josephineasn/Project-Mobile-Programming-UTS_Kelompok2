import 'package:flutter/material.dart';
import '../services/premium_controller.dart';
import '../widgets/premium/premium_plan_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  // Pop-up Terms & Apply
  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E212B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Syarat & Ketentuan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Langganan berlaku otomatis sesuai periode paket yang dipilih.\n\n'
            '2. Pembayaran yang sudah berhasil tidak dapat dikembalikan (non-refundable).\n\n'
            '3. Kamu dapat membatalkan langganan kapan saja sebelum tanggal jatuh tempo berikutnya.\n\n'
            '4. Akses download offline dan kualitas audio tinggi aktif seketika setelah pembayaran terkonfirmasi.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Pop-up Pilihan Metode Pembayaran & Konfirmasi Bayar
  void _showCheckoutDialog(BuildContext context, String planTitle, String price) {
    String selectedPayment = 'GoPay';

    final paymentMethods = [
      {'name': 'GoPay', 'icon': Icons.account_balance_wallet_outlined},
      {'name': 'DANA', 'icon': Icons.wallet_outlined},
      {'name': 'OVO', 'icon': Icons.payments_outlined},
      {'name': 'Transfer Bank (BCA/Mandiri)', 'icon': Icons.account_balance_outlined},
      {'name': 'Kartu Debit / Kredit', 'icon': Icons.credit_card_outlined},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E212B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Langganan $planTitle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total tagihan: $price',
                    style: const TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih Metode Pembayaran:',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  // Daftar Pilihan Pembayaran
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
                          color: isChosen ? Colors.white.withAlpha(25) : Colors.white.withAlpha(10),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isChosen ? Colors.amber : Colors.white12,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, color: isChosen ? Colors.amber : Colors.white70, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: isChosen ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            Icon(
                              isChosen ? Icons.check_circle_rounded : Icons.radio_button_off,
                              color: isChosen ? Colors.amber : Colors.white30,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Tombol Bayar Sekarang
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      onPressed: () {
                        // Ubah status ke Premium!
                        PremiumController.activatePremium(planTitle);

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.amber,
                            content: Text(
                              'Berhasil berlangganan $planTitle via $selectedPayment!',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      child: const Text('Bayar Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // Cover album di header
  Widget _buildAlbumTile(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(url, fit: BoxFit.cover),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.45, 0.85, 1.0],
                        colors: [
                          Colors.transparent,
                          bgColor.withAlpha(153),
                          bgColor.withAlpha(242),
                          bgColor,
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
                  Row(
                    children: [
                      Icon(Icons.album_outlined, color: textColor, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Premium',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Headline Besar
                  Text(
                    'Get more out of your\nmusic with Premium\nStandard.',
                    style: TextStyle(
                      color: textColor,
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
                        'Get Premium Standard',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Syarat & Ketentuan (klik untuk pop-up)
                  GestureDetector(
                    onTap: () => _showTermsDialog(context),
                    child: Text(
                      'Terms apply.',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'See other plans below.',
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Kotak Why join Premium Standard?
                  const PremiumBenefitsCard(),
                  const SizedBox(height: 36),

                  // Available plans
                  Text(
                    'Available plans',
                    style: TextStyle(
                      color: textColor,
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
                    onSelect: () => _showCheckoutDialog(
                      context,
                      'Standard',
                      'IDR 59,900 / month',
                    ),
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
                    onSelect: () => _showCheckoutDialog(
                      context,
                      'Platinum',
                      'IDR 119,900 / month',
                    ),
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
                    onSelect: () => _showCheckoutDialog(
                      context,
                      'Student',
                      'IDR 29,900 / month',
                    ),
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
                    onSelect: () => _showCheckoutDialog(
                      context,
                      'Family',
                      'IDR 86,900 / month',
                    ),
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
}