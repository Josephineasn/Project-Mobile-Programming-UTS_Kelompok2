import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/premium_screen.dart';
import '../services/audio_controller.dart';
import '../services/premium_controller.dart';
import '../widgets/settings/user_profile_header.dart';
import '../widgets/settings/plan_status_card.dart';
import '../widgets/settings/account_setting_tile.dart';
import '../widgets/settings/theme_toggle_switch.dart';
import '../widgets/settings/logout_button.dart';

// Model data akun dengan autentikasi password
class UserAccountData {
  final String name;
  final String email;
  final String password;
  final bool isLoggedIn;
  final bool isPremium;

  const UserAccountData({
    required this.name,
    required this.email,
    required this.password,
    required this.isLoggedIn,
    this.isPremium = false,
  });

  UserAccountData copyWith({
    String? name,
    String? email,
    String? password,
    bool? isLoggedIn,
    bool? isPremium,
  }) {
    return UserAccountData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

// Model item notifikasi
class AppNotificationItem {
  final String id;
  final String title;
  final String desc;
  final String time;
  final String type;
  bool isRead;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// Service Notifikasi Melodix
class AppNotificationService {
  static final ValueNotifier<bool> notificationEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<List<AppNotificationItem>> notifications =
      ValueNotifier<List<AppNotificationItem>>([
    AppNotificationItem(
      id: 'welcome_initial',
      title: 'Welcome to Melodix!',
      desc: 'Start exploring and playing your favorite music.',
      time: 'Just now',
      type: 'welcome',
      isRead: false,
    ),
  ]);

  static String _lastPlayingSong = '';

  static void addNotification({
    required String id,
    required String title,
    required String desc,
    required String type,
  }) {
    if (!notificationEnabled.value) return;

    final currentList = List<AppNotificationItem>.from(notifications.value);
    currentList.removeWhere((item) => item.id == id);

    currentList.insert(
      0,
      AppNotificationItem(
        id: id,
        title: title,
        desc: desc,
        time: 'Just now',
        type: type,
        isRead: false,
      ),
    );

    notifications.value = currentList;
  }

  static void markAllAsRead() {
    final updatedList = notifications.value.map((item) {
      item.isRead = true;
      return item;
    }).toList();
    notifications.value = List<AppNotificationItem>.from(updatedList);
  }

  static void clearAllNotifications() {
    _lastPlayingSong = '';
    notifications.value = [];
  }

  static void syncPlayingSong({
    required String title,
    required String artist,
    required bool isPrivateSession,
    required bool showListeningActivity,
  }) {
    if (!notificationEnabled.value) return;
    if (isPrivateSession || !showListeningActivity) return;
    if (_lastPlayingSong == title) return;
    _lastPlayingSong = title;

    addNotification(
      id: 'now_playing',
      title: 'Now Playing',
      desc: '$title • $artist',
      type: 'music',
    );
  }

  static void handleLoginEvent(String name, String email) {
    if (!notificationEnabled.value) return;

    addNotification(
      id: 'login_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Signed in successfully',
      desc: 'Logged in as $name ($email)',
      type: 'login',
    );

    addNotification(
      id: 'welcome_$name',
      title: 'Welcome, $name!',
      desc: 'Glad to have you back on Melodix.',
      type: 'welcome',
    );
  }

  static void handlePremiumActivated(String planName) {
    if (!notificationEnabled.value) return;

    addNotification(
      id: 'premium_${DateTime.now().millisecondsSinceEpoch}',
      title: "You're now Premium",
      desc: 'Enjoy unlimited offline playback and studio audio quality ($planName).',
      type: 'premium',
    );
  }

  static void clearMusicNotification() {
    _lastPlayingSong = '';
    final currentList = List<AppNotificationItem>.from(notifications.value);
    currentList.removeWhere((item) => item.id == 'now_playing');
    notifications.value = currentList;
  }
}

// Master Akun Terdaftar (Database / Authentication Registry)
final List<UserAccountData> registeredAccountsRegistry = [
  const UserAccountData(name: 'Josephine', email: 'josephine@example.com', password: 'josephine123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Gading', email: 'gading@example.com', password: 'gading123', isLoggedIn: true, isPremium: true),
  const UserAccountData(name: 'Sherly', email: 'sherly@example.com', password: 'sherly123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Calvin', email: 'calvin@example.com', password: 'calvin123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Hans', email: 'hans@example.com', password: 'hans123', isLoggedIn: false, isPremium: false),
];

// Akun Tersimpan di Perangkat (Saved Accounts Shortcut)
final ValueNotifier<List<UserAccountData>> savedAccountsNotifier = ValueNotifier<List<UserAccountData>>([
  const UserAccountData(name: 'Josephine', email: 'josephine@example.com', password: 'josephine123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Gading', email: 'gading@example.com', password: 'gading123', isLoggedIn: true, isPremium: true),
  const UserAccountData(name: 'Sherly', email: 'sherly@example.com', password: 'sherly123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Calvin', email: 'calvin@example.com', password: 'calvin123', isLoggedIn: false, isPremium: false),
  const UserAccountData(name: 'Hans', email: 'hans@example.com', password: 'hans123', isLoggedIn: false, isPremium: false),
]);

// Akun Aktif
final ValueNotifier<UserAccountData> currentAccountNotifier = ValueNotifier<UserAccountData>(
  const UserAccountData(name: 'Gading', email: 'gading@example.com', password: 'gading123', isLoggedIn: true, isPremium: true),
);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentQuality = 'Automatic';
  bool _privateSession = false;
  bool _showListening = true;

  OverlayEntry? _toastEntry;

  @override
  void initState() {
    super.initState();
    AudioController.instance.addListener(_handleAudioChange);
    PremiumController.isPremium.addListener(_handlePremiumChange);
  }

  @override
  void dispose() {
    AudioController.instance.removeListener(_handleAudioChange);
    PremiumController.isPremium.removeListener(_handlePremiumChange);
    super.dispose();
  }

  void _handlePremiumChange() {
    final isPrem = PremiumController.isPremium.value;
    if (currentAccountNotifier.value.isLoggedIn) {
      currentAccountNotifier.value = currentAccountNotifier.value.copyWith(isPremium: isPrem);

      final idx = registeredAccountsRegistry.indexWhere((a) => a.email.toLowerCase() == currentAccountNotifier.value.email.toLowerCase());
      if (idx != -1) {
        registeredAccountsRegistry[idx] = registeredAccountsRegistry[idx].copyWith(isPremium: isPrem);
      }

      final savedIdx = savedAccountsNotifier.value.indexWhere((a) => a.email.toLowerCase() == currentAccountNotifier.value.email.toLowerCase());
      if (savedIdx != -1) {
        final list = List<UserAccountData>.from(savedAccountsNotifier.value);
        list[savedIdx] = list[savedIdx].copyWith(isPremium: isPrem);
        savedAccountsNotifier.value = list;
      }

      if (isPrem) {
        AppNotificationService.handlePremiumActivated(PremiumController.currentPlan.value);
      }
    }
    if (mounted) setState(() {});
  }

  void _handleAudioChange() {
    final audio = AudioController.instance;
    if (audio.isPlaying && audio.currentSong != null) {
      AppNotificationService.syncPlayingSong(
        title: audio.currentSong!.title,
        artist: audio.currentSong!.artist,
        isPrivateSession: _privateSession,
        showListeningActivity: _showListening,
      );
    }
  }

  void _showNotification(String message, {double bottomPosition = 270}) {
    _toastEntry?.remove();
    _toastEntry = null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: bottomPosition,
        left: 28,
        right: 28,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF383838) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isDark ? Colors.white30 : Colors.black26,
                  width: 1.5,
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

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_toastEntry == entry) {
        _toastEntry?.remove();
        _toastEntry = null;
      }
    });
  }

  // 1. Auth Options (Create Account vs I Already Have an Account)
  void _showAuthOptionsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to Melodix',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join millions of music lovers or log back in.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showRegistrationDialog();
                  },
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? Colors.white38 : Colors.black26),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showChooseAccountPicker();
                  },
                  child: Text(
                    'I already have an account',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Create an Account: Memerlukan Name, Email, dan Password dengan Show/Hide
  void _showRegistrationDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
          title: const Text('Create an Account'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                final pass = passCtrl.text;

                if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                  _showNotification('Please fill in all fields', bottomPosition: 200);
                  return;
                }

                final exists = registeredAccountsRegistry.any((a) => a.email.toLowerCase() == email.toLowerCase());
                if (exists) {
                  _showNotification('An account with this email already exists', bottomPosition: 200);
                  return;
                }

                final newAccount = UserAccountData(
                  name: name,
                  email: email,
                  password: pass,
                  isLoggedIn: true,
                  isPremium: false,
                );

                registeredAccountsRegistry.add(newAccount);

                final updatedSaved = List<UserAccountData>.from(savedAccountsNotifier.value)..add(newAccount);
                savedAccountsNotifier.value = updatedSaved;

                currentAccountNotifier.value = newAccount;
                PremiumController.cancelPremium();

                AppNotificationService.handleLoginEvent(name, email);

                Navigator.pop(ctx);
                setState(() {});
                _showNotification('Account created successfully', bottomPosition: 200);
              },
              child: const Text('Sign Up', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog Password untuk Akun yang Dipilih (Password Only) dengan Show/Hide
  void _showPasswordPromptDialog(UserAccountData acc, BuildContext parentModalCtx) {
    final passCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
          title: Text('Enter Password for ${acc.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                acc.email,
                style: TextStyle(color: isDark ? Colors.white60 : Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passCtrl,
                autofocus: true,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final enteredPass = passCtrl.text;
                if (enteredPass.isEmpty) {
                  _showNotification('Password is required', bottomPosition: 200);
                  return;
                }

                final registered = registeredAccountsRegistry.firstWhere(
                  (a) => a.email.toLowerCase() == acc.email.toLowerCase(),
                  orElse: () => acc,
                );

                if (registered.password != enteredPass) {
                  Navigator.pop(ctx);
                  _showNotification('Incorrect password.', bottomPosition: 200);
                  return;
                }

                final updatedAcc = registered.copyWith(isLoggedIn: true);
                currentAccountNotifier.value = updatedAcc;

                if (updatedAcc.isPremium) {
                  PremiumController.activatePremium('Melodix Premium');
                } else {
                  PremiumController.cancelPremium();
                }

                AppNotificationService.handleLoginEvent(updatedAcc.name, updatedAcc.email);

                Navigator.pop(ctx);
                Navigator.pop(parentModalCtx);
                setState(() {});
                _showNotification('Signed in as ${updatedAcc.name}', bottomPosition: 200);
              },
              child: const Text('Continue', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Remove Account Dialog
  void _showRemoveAccountConfirmDialog(UserAccountData acc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Account?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Remove "${acc.name}" from your saved accounts? You can still sign in again later.',
          style: const TextStyle(color: Colors.white70, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _removeSavedAccount(acc);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _removeSavedAccount(UserAccountData acc) {
    final updatedList = List<UserAccountData>.from(savedAccountsNotifier.value)
      ..removeWhere((a) => a.email.toLowerCase() == acc.email.toLowerCase());
    savedAccountsNotifier.value = updatedList;

    if (currentAccountNotifier.value.isLoggedIn &&
        currentAccountNotifier.value.email.toLowerCase() == acc.email.toLowerCase()) {
      AudioController.instance.player.stop();
      AppNotificationService.clearMusicNotification();

      currentAccountNotifier.value = const UserAccountData(
        name: 'Guest',
        email: 'guest@melodix.com',
        password: '',
        isLoggedIn: false,
        isPremium: false,
      );
      PremiumController.cancelPremium();
    }

    setState(() {});
    _showNotification('Account removed from saved list', bottomPosition: 200);
  }

  // Modal Sheet: Choose Account
  void _showChooseAccountPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: ValueListenableBuilder<List<UserAccountData>>(
              valueListenable: savedAccountsNotifier,
              builder: (context, savedList, _) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          'Choose Account',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      if (savedList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'No saved accounts found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ...savedList.map((acc) {
                        final isCurrent = currentAccountNotifier.value.isLoggedIn &&
                            currentAccountNotifier.value.email.toLowerCase() == acc.email.toLowerCase();

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF1DB954),
                            child: Text(
                              acc.name.isNotEmpty ? acc.name[0] : 'U',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(acc.name),
                          subtitle: Text('${acc.email} • ${acc.isPremium ? 'Premium' : 'Free'}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isCurrent)
                                const Padding(
                                  padding: EdgeInsets.only(right: 6.0),
                                  child: Icon(Icons.check_circle, color: Color(0xFF1DB954), size: 22),
                                ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 20),
                                tooltip: 'Remove account',
                                onPressed: () {
                                  _showRemoveAccountConfirmDialog(acc);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            if (isCurrent) {
                              Navigator.pop(ctx);
                              return;
                            }
                            _showPasswordPromptDialog(acc, ctx);
                          },
                        );
                      }),
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                        title: const Text('Sign in with another account'),
                        onTap: () {
                          Navigator.pop(ctx);
                          _showManualSignInDialog();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Sign in with another account: Name + Email + Password dengan Show/Hide
  void _showManualSignInDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
          title: const Text('Sign In'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
              onPressed: () {
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();
                final pass = passCtrl.text;

                if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                  _showNotification('Please fill in all fields', bottomPosition: 200);
                  return;
                }

                // Validasi Kredensial: Name, Email, Password HARUS COCOK
                final matchIdx = registeredAccountsRegistry.indexWhere((a) =>
                    a.email.toLowerCase() == email.toLowerCase() &&
                    a.name.trim().toLowerCase() == name.toLowerCase() &&
                    a.password == pass);

                if (matchIdx == -1) {
                  _showNotification('Invalid name, email, or password.', bottomPosition: 200);
                  return;
                }

                final matchedAcc = registeredAccountsRegistry[matchIdx].copyWith(isLoggedIn: true);

                final currentSaved = List<UserAccountData>.from(savedAccountsNotifier.value);
                final savedIdx = currentSaved.indexWhere((a) => a.email.toLowerCase() == email.toLowerCase());
                if (savedIdx == -1) {
                  currentSaved.add(matchedAcc);
                } else {
                  currentSaved[savedIdx] = matchedAcc;
                }
                savedAccountsNotifier.value = currentSaved;

                currentAccountNotifier.value = matchedAcc;
                if (matchedAcc.isPremium) {
                  PremiumController.activatePremium('Melodix Premium');
                } else {
                  PremiumController.cancelPremium();
                }

                AppNotificationService.handleLoginEvent(matchedAcc.name, matchedAcc.email);

                Navigator.pop(ctx);
                setState(() {});
                _showNotification('Signed in as ${matchedAcc.name}', bottomPosition: 200);
              },
              child: const Text('Sign In', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Edit Profile
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: currentAccountNotifier.value.name);
    final emailController = TextEditingController(text: currentAccountNotifier.value.email);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        title: const Text('Edit Profile'),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = nameController.text.trim();
              final newEmail = emailController.text.trim();
              if (newName.isNotEmpty && newEmail.isNotEmpty) {
                final updated = currentAccountNotifier.value.copyWith(name: newName, email: newEmail);
                currentAccountNotifier.value = updated;

                final regIdx = registeredAccountsRegistry.indexWhere((a) => a.email.toLowerCase() == updated.email.toLowerCase());
                if (regIdx != -1) registeredAccountsRegistry[regIdx] = updated;

                final savedIdx = savedAccountsNotifier.value.indexWhere((a) => a.email.toLowerCase() == updated.email.toLowerCase());
                if (savedIdx != -1) {
                  final list = List<UserAccountData>.from(savedAccountsNotifier.value);
                  list[savedIdx] = updated;
                  savedAccountsNotifier.value = list;
                }

                Navigator.pop(ctx);
                setState(() {});
                _showNotification('Profile updated', bottomPosition: 200);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 3. Account Settings Modal
  void _showAccountDetails() {
    final account = currentAccountNotifier.value;
    final isPrem = PremiumController.isPremium.value || account.isPremium;

    _showSettingsBottomSheet(
      title: 'Account Settings',
      children: [
        if (account.isLoggedIn) ...[
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account Name'),
            subtitle: Text(account.name),
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Registered Email'),
            subtitle: Text(account.email),
          ),
          ListTile(
            leading: const Icon(Icons.card_membership_outlined),
            title: const Text('Subscription'),
            subtitle: Text(isPrem ? 'Melodix Premium' : 'Melodix Free'),
            trailing: isPrem ? const Icon(Icons.stars, color: Color(0xFF1DB954)) : null,
          ),
          ListTile(
            leading: const Icon(Icons.switch_account_outlined),
            title: const Text('Switch Account'),
            subtitle: const Text('Sign in with a different profile'),
            onTap: () {
              Navigator.pop(context);
              _showChooseAccountPicker();
            },
          ),
        ] else ...[
          ListTile(
            leading: const Icon(Icons.login_rounded),
            title: const Text('Sign In to Melodix'),
            subtitle: const Text('Access your customized playlists and profile'),
            onTap: () {
              Navigator.pop(context);
              _showAuthOptionsSheet();
            },
          ),
        ],
      ],
    );
  }

  // 4. Notifications Settings Modal
  void _showNotificationsSettings() {
    _showSettingsBottomSheet(
      title: 'Notifications',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              children: [
                SwitchListTile(
                  title: const Text('Activity & Alerts'),
                  subtitle: const Text('Track music updates, login events, and account status in Home bell'),
                  activeThumbColor: const Color(0xFF1DB954),
                  value: AppNotificationService.notificationEnabled.value,
                  onChanged: (val) {
                    setModalState(() {
                      AppNotificationService.notificationEnabled.value = val;
                    });
                    setState(() {});
                    _showNotification(
                      val ? 'Notifications enabled' : 'Notifications disabled',
                      bottomPosition: 260,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: const Text('View Notification Bell'),
                  subtitle: Text(
                    '${AppNotificationService.notifications.value.length} activity items recorded',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showNotificationBellViewer();
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showNotificationBellViewer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppNotificationService.markAllAsRead();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.notifications_active, color: Color(0xFF1DB954)),
                SizedBox(width: 8),
                Text('Notifications Bell', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ],
            ),
            ValueListenableBuilder<List<AppNotificationItem>>(
              valueListenable: AppNotificationService.notifications,
              builder: (context, notifs, _) {
                if (notifs.isEmpty) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        backgroundColor: const Color(0xFF282828),
                        title: const Text('Clear Notifications?', style: TextStyle(color: Colors.white)),
                        content: const Text(
                          'All notification history will be removed.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            onPressed: () {
                              AppNotificationService.clearAllNotifications();
                              Navigator.pop(c);
                            },
                            child: const Text('Clear', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Clear all', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                );
              },
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ValueListenableBuilder<List<AppNotificationItem>>(
            valueListenable: AppNotificationService.notifications,
            builder: (context, notifList, _) {
              if (notifList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No notifications')),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                itemCount: notifList.length,
                separatorBuilder: (_, _) => const Divider(),
                itemBuilder: (context, idx) {
                  final item = notifList[idx];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text(item.desc, style: const TextStyle(fontSize: 12)),
                    trailing: Text(item.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // 5. Audio Quality
  void _showAudioQualitySettings() {
    final isPrem = PremiumController.isPremium.value || currentAccountNotifier.value.isPremium;

    final listQualities = [
      {'title': 'Automatic', 'desc': 'Optimizes with your network'},
      {'title': 'Normal (~96 kbps)', 'desc': 'Data saver'},
      {'title': 'High (~160 kbps)', 'desc': 'Standard clear audio'},
      {'title': 'Very High (~320 kbps)', 'desc': 'Studio master quality'},
    ];

    _showSettingsBottomSheet(
      title: 'Audio Quality',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: listQualities.map((q) {
              final title = q['title']!;
              final desc = q['desc']!;
              final isSelected = _currentQuality == title;
              final isRestricted = title.contains('320 kbps') && !isPrem;

              return ListTile(
                title: Text(title),
                subtitle: Text(desc),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Color(0xFF1DB954))
                    : (isRestricted ? const Icon(Icons.lock_outline, size: 18) : null),
                onTap: () {
                  if (isRestricted) {
                    showDialog(
                      context: context,
                      builder: (dialogCtx) => AlertDialog(
                        title: const Text('Premium Feature'),
                        content: const Text(
                          'Very High quality (~320 kbps) is exclusively available for Melodix Premium subscribers.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogCtx),
                            child: const Text('Later'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1DB954)),
                            onPressed: () {
                              Navigator.pop(dialogCtx);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PremiumScreen()),
                              );
                            },
                            child: const Text('Upgrade Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  setModalState(() => _currentQuality = title);
                  setState(() => _currentQuality = title);
                  _showNotification('Quality: $title', bottomPosition: 405);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 6. Privacy & Social
  void _showPrivacySocialSettings() {
    _showSettingsBottomSheet(
      title: 'Privacy & Social',
      children: [
        StatefulBuilder(
          builder: (context, setModalState) => Column(
            children: [
              SwitchListTile(
                title: const Text('Private Session'),
                subtitle: const Text('Listen privately. Hides your status and pauses public listening activity.'),
                activeThumbColor: const Color(0xFF1DB954),
                value: _privateSession,
                onChanged: (val) {
                  setModalState(() => _privateSession = val);
                  setState(() => _privateSession = val);
                  if (val) {
                    AppNotificationService.clearMusicNotification();
                  }
                  _showNotification(
                    val ? 'Private Session enabled' : 'Private Session disabled',
                    bottomPosition: 245,
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Show Listening Activity'),
                subtitle: const Text('Broadcast current songs to your followers when not in Private Session.'),
                activeThumbColor: const Color(0xFF1DB954),
                value: _showListening,
                onChanged: (val) {
                  setModalState(() => _showListening = val);
                  setState(() => _showListening = val);
                  if (!val) {
                    AppNotificationService.clearMusicNotification();
                  }
                  _showNotification(
                    val ? 'Listening activity shared' : 'Listening activity hidden',
                    bottomPosition: 245,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSettingsBottomSheet({
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
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
          ),
        );
      },
    );
  }

  void _executeLogout() {
    AudioController.instance.player.stop();
    AppNotificationService.clearMusicNotification();

    currentAccountNotifier.value = const UserAccountData(
      name: 'Guest',
      email: 'guest@melodix.com',
      password: '',
      isLoggedIn: false,
      isPremium: false,
    );
    PremiumController.cancelPremium();

    setState(() {});
    _showNotification('Logged out successfully', bottomPosition: 200);
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
      body: ValueListenableBuilder<UserAccountData>(
        valueListenable: currentAccountNotifier,
        builder: (context, account, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: PremiumController.isPremium,
            builder: (context, isPremiumActive, _) {
              final isPrem = isPremiumActive || account.isPremium;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  UserProfileHeader(
                    userName: account.name,
                    userEmail: account.email,
                    isPrivateSession: _privateSession,
                    onEditProfile: account.isLoggedIn ? _showEditProfileDialog : _showAuthOptionsSheet,
                  ),
                  PlanStatusCard(
                    planName: isPrem ? 'Melodix Premium' : 'Melodix Free',
                    planDescription: isPrem
                        ? 'Unlimited skips, offline listening, and high-fidelity studio sound.'
                        : 'Enjoy music with ad breaks. Upgrade to get unlimited and offline listening.',
                    isPremium: isPrem,
                    onUpgradePressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PremiumScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AccountSettingTile(
                    icon: Icons.person_outline,
                    title: 'Account',
                    subtitle: account.isLoggedIn
                        ? '${account.name} • ${account.email}'
                        : 'Not signed in (Tap to sign in)',
                    onTap: _showAccountDetails,
                  ),
                  AccountSettingTile(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    subtitle: AppNotificationService.notificationEnabled.value
                        ? 'Notifications are on'
                        : 'Notifications are off',
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
                      _showNotification(
                        val ? 'Dark Mode enabled' : 'Light Mode enabled',
                        bottomPosition: 100,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  if (account.isLoggedIn)
                    LogoutButton(
                      onLogout: _executeLogout,
                    ),
                  const SizedBox(height: 40),
                ],
              );
            },
          );
        },
      ),
    );
  }
}