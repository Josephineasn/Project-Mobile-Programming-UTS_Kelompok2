import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/premium_screen.dart';
import '../widgets/settings/user_profile_header.dart';
import '../widgets/settings/plan_status_card.dart';
import '../widgets/settings/account_setting_tile.dart';
import '../widgets/settings/theme_toggle_switch.dart';
import '../widgets/settings/logout_button.dart';
import '../screens/main_navigation_screen.dart';
import '../services/premium_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = 'John Doe';
  String _userEmail = 'johndoe@example.com';

  String _currentQuality = 'Otomatis';
  bool _pushNotif = true;
  bool _emailUpdates = false;
  bool _privateSession = false;
  bool _showListening = true;

  OverlayEntry? _toastEntry;

  // Pop-up melayang
  void _showNotification(String message) {
    _toastEntry?.remove();
    _toastEntry = null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 275,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
          
                color: isDark ? const Color(0xFF333333) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.white30 : Colors.black26,
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _toastEntry = entry;
    Overlay.of(context).insert(entry);

    // Otomatis hilang setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_toastEntry == entry) {
        _toastEntry?.remove();
        _toastEntry = null;
      }
    });
  }

  // Edit Profil
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text.trim();
                _userEmail = emailController.text.trim();
              });
              Navigator.pop(context);
              _showNotification('Profil berhasil diubah');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Akun
  void _showAccountDetails() {
    _showSettingsBottomSheet(
      title: 'Setting account',
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Username'),
          subtitle: Text(_userName),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email'),
          subtitle: Text(_userEmail),
        ),
      ],
    );
  }

  // Notifikasi
  void _showNotificationsSettings() {
    _showSettingsBottomSheet(
      title: 'Notifikasi',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Recommendation music & New playlist'),
                activeThumbColor: Colors.green,
                value: _pushNotif,
                onChanged: (val) {
                  setModalState(() => _pushNotif = val);
                  setState(() => _pushNotif = val);
                  _showNotification(
                    val ? 'Push Notifications Enabled' : 'Push Notifications Disabled',
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Email Updates'),
                subtitle: const Text('Notification promo & fitur terbaru'),
                activeThumbColor: Colors.green,
                value: _emailUpdates,
                onChanged: (val) {
                  setModalState(() => _emailUpdates = val);
                  setState(() => _emailUpdates = val);
                  _showNotification(
                    val ? 'Email updates enabled' : 'Email updates disabled'
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Kualitas Audio
  void _showAudioQualitySettings() {
    final listKualitas = [
      'Otomatis',
      'Normal (~96 kbps)',
      'Tinggi (~160 kbps)',
      'Sangat Tinggi (~320 kbps)',
    ];

    _showSettingsBottomSheet(
      title: 'Kualitas Audio',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: listKualitas.map((kualitas) {
              final isSelected = _currentQuality == kualitas;
              final isPremium = kualitas == 'Sangat Tinggi (~320 kbps)';

              return ListTile(
                title: Text(kualitas),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Colors.green)
                    : (isPremium ? const Icon(Icons.lock, size: 18) : null),
                onTap: () {
                  if (isPremium) {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Fitur Premium'),
                        content: const Text(
                          'Kualitas Sangat Tinggi hanya untuk pengguna Premium. Upgrade sekarang?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text('Nanti'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PremiumScreen(),
                                ),
                              );
                            },
                            child: const Text('Upgrade Sekarang'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  setModalState(() => _currentQuality = kualitas);
                  setState(() => _currentQuality = kualitas);
                  _showNotification('Kualitas: $kualitas');
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Privasi & Sosial
  void _showPrivacySocialSettings() {
    _showSettingsBottomSheet(
      title: 'Privasi & Sosial',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              SwitchListTile(
                title: const Text('Sesi Pribadi (Private Session)'),
                subtitle: const Text('Dengarkan musik tanpa terlihat teman'),
                activeThumbColor: Colors.green,
                value: _privateSession,
                onChanged: (val) {
                  setModalState(() => _privateSession = val);
                  setState(() => _privateSession = val);
                  _showNotification(
                    val ? 'Private Session Enabled' : 'Private Session Disabled',
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Listening activity'),
                subtitle: const Text('Share what you play with your followers'),
                activeThumbColor: Colors.green,
                value: _showListening,
                onChanged: (val) {
                  setModalState(() => _showListening = val);
                  setState(() => _showListening = val);
                  _showNotification(
                    val ? 'Listening Activity Shown' : 'Listening Activity Hidden',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Bottom Sheet Standar
  void _showSettingsBottomSheet({
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 35,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ...children,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          UserProfileHeader(
            userName: _userName,
            userEmail: _userEmail,
            onEditProfile: _showEditProfileDialog,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: PremiumController.isPremium,
            builder: (context, isPremium, child) {
              return PlanStatusCard(
                planName: isPremium ? 'Melodix ${PremiumController.currentPlan.value}' : 'Melodix Free',
                planDescription: isPremium
                    ? 'Akun kamu aktif menikmati fitur bebas iklan dan kualitas audio tinggi.'
                    : 'Enjoy music with ad breaks. Upgrade to get unlimited and offline listening.',
                isPremium: isPremium,
                onUpgradePressed: () {
                  if (!isPremium) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainNavScreen(initialIndex: 4),
                      ),
                      (route) => false,
                    );
                  } else {
                    // Batalin premium
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        backgroundColor: const Color(0xFF242424),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text(
                          'Kelola Langganan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Paket kamu saat ini: ${PremiumController.currentPlan.value}.\nApakah kamu ingin membatalkan langganan Premium?',
                          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text('Tetap Berlangganan', style: TextStyle(color: Colors.white70)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            onPressed: () {
                              // Reset status ke free
                              PremiumController.cancelPremium();
                              Navigator.pop(dialogCtx);
                              _showNotification('Langganan Premium berhasil dibatalkan');
                            },
                            child: const Text('Batalkan Langganan'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),
          const SizedBox(height: 12),
          AccountSettingTile(
            icon: Icons.person_outline,
            title: 'Account',
            subtitle: 'Username, email, connected accounts',
            onTap: _showAccountDetails,
          ),
          AccountSettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Push notifications, email updates',
            onTap: _showNotificationsSettings,
          ),
          AccountSettingTile(
            icon: Icons.volume_up_outlined,
            title: 'Audio Quality',
            subtitle: 'Streaming and download settings',
            onTap: _showAudioQualitySettings,
          ),
          AccountSettingTile(
            icon: Icons.security_outlined,
            title: 'Privacy & Social',
            subtitle: 'Listening activity, private session',
            onTap: _showPrivacySocialSettings,
          ),
          ThemeToggleSwitch(
            onToggle: (bool val) {
              themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              _showNotification(val ? 'Dark mode enabled' : 'Light mode enabled');
            },
          ),
          const SizedBox(height: 20),
          LogoutButton(
            onLogout: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showNotification('Successfully logged out');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}