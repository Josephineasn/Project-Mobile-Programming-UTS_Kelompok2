import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../screens/settings_screen.dart';

class HeaderGreetingWidget extends StatelessWidget {
  final String salam;
  final String? profileImageUrl;

  const HeaderGreetingWidget({
    super.key,
    required this.salam,
    this.profileImageUrl,
  });

  void _showClearConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF282828),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Clear Notifications?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'All notification history will be removed. Your notification settings will remain unchanged.',
          style: TextStyle(color: Colors.white70, fontSize: 13.5),
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
              AppNotificationService.clearAllNotifications();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showNotificationBellDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    AppNotificationService.markAllAsRead();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.notifications_active, color: Color(0xFF1DB954)),
                SizedBox(width: 8),
                Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            ValueListenableBuilder<List<AppNotificationItem>>(
              valueListenable: AppNotificationService.notifications,
              builder: (context, notifs, _) {
                if (notifs.isEmpty) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () {
                    _showClearConfirmDialog(context);
                  },
                  child: const Text(
                    'Clear all',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ValueListenableBuilder<List<AppNotificationItem>>(
            valueListenable: AppNotificationService.notifications,
            builder: (context, list, _) {
              if (!AppNotificationService.notificationEnabled.value) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'Notifications are disabled in Settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(
                    child: Text(
                      'No notifications yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final notif = list[idx];
                  IconData icon = Icons.info_outline;
                  if (notif.type == 'music') icon = Icons.music_note_rounded;
                  if (notif.type == 'login') icon = Icons.login_rounded;
                  if (notif.type == 'welcome') icon = Icons.waving_hand_rounded;
                  if (notif.type == 'premium') icon = Icons.workspace_premium_rounded;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: notif.isRead
                              ? Colors.grey.withAlpha(40)
                              : const Color(0xFF1DB954).withAlpha(40),
                          child: Icon(
                            icon,
                            color: notif.isRead ? Colors.grey : const Color(0xFF1DB954),
                            size: 20,
                          ),
                        ),
                        if (!notif.isRead)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1DB954),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: Text(
                      notif.desc,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      notif.time,
                      style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF1DB954))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contentColor = isDark ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryGreen,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : null,
            child: profileImageUrl == null
                ? const Icon(Icons.person, size: 20, color: Colors.black)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              salam,
              style: TextStyle(
                color: contentColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ValueListenableBuilder<List<AppNotificationItem>>(
            valueListenable: AppNotificationService.notifications,
            builder: (context, notifs, _) {
              final hasUnread = AppNotificationService.notificationEnabled.value &&
                  notifs.any((n) => !n.isRead);

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    icon: Icon(
                      hasUnread ? Icons.notifications_active : Icons.notifications_none,
                      color: hasUnread ? const Color(0xFF1DB954) : contentColor,
                      size: 24,
                    ),
                    onPressed: () => _showNotificationBellDialog(context),
                  ),
                  if (hasUnread)
                    Positioned(
                      top: 8,
                      right: 6,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1DB954),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            icon: Icon(Icons.history, color: contentColor, size: 24),
            onPressed: () {},
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 6),
            icon: Icon(Icons.settings_outlined, color: contentColor, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}