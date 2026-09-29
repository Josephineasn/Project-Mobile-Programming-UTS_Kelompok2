import 'package:flutter/material.dart';

class ThemeToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  const ThemeToggleSwitch({
    super.key,
    this.initialValue = true, // Default dark mode aktif
    required this.onToggle,
  });

  @override
  State<ThemeToggleSwitch> createState() => _ThemeToggleSwitchState();
}

class _ThemeToggleSwitchState extends State<ThemeToggleSwitch> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          color: isDark ? Colors.white : Colors.black87,
          size: 22,
        ),
      ),
      title: Text(
        'Dark Mode',
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        _isDarkMode ? 'Tema gelap aktif' : 'Tema terang aktif',
        style: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: _isDarkMode,
        activeColor: const Color(0xFF1DB954),
        activeTrackColor: const Color(0xFF1DB954).withOpacity(0.4),
        inactiveThumbColor: Colors.grey.shade600,
        inactiveTrackColor: Colors.black12,
        onChanged: (bool value) {
          setState(() {
            _isDarkMode = value;
          });
          widget.onToggle(value);
        },
      ),
    );
  }
}