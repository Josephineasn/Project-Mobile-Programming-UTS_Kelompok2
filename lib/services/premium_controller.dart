import 'package:flutter/material.dart';

class PremiumController {
  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
  static final ValueNotifier<String> currentPlan = ValueNotifier<String>('Free Plan');

  // Aktifkan premium
  static void activatePremium(String planName) {
    isPremium.value = true;
    currentPlan.value = planName;
  }

  // Batalkan langganan kembali ke Free
  static void cancelPremium() {
    isPremium.value = false;
    currentPlan.value = 'Free Plan';
  }
}