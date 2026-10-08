import 'package:flutter/material.dart';
import '../screens/settings_screen.dart';

class PremiumController {
  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
  static final ValueNotifier<String> currentPlan = ValueNotifier<String>('Free Plan');

  // Aktifkan premium
  static void activatePremium(String planName) {
    isPremium.value = true;
    currentPlan.value = planName;

    final account = currentAccountNotifier.value;
    try {
      currentAccountNotifier.value = account.copyWith(isPremium: true);
    } catch (_) {
    }
  }

  // Batalkan langganan kembali ke Free
  static void cancelPremium() {
    isPremium.value = false;
    currentPlan.value = 'Free Plan';

    final account = currentAccountNotifier.value;
    try {
      currentAccountNotifier.value = account.copyWith(isPremium: false);
    } catch (_) {
    }
  }
}