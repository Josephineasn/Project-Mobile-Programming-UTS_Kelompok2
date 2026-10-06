import 'package:flutter/material.dart';

class PlanStatusCard extends StatelessWidget {
  final String planName;
  final String planDescription;
  final bool isPremium;
  final VoidCallback onUpgradePressed;

  const PlanStatusCard({
    super.key,
    required this.planName,
    required this.planDescription,
    this.isPremium = false,
    required this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPremium
              ? [const Color(0xFF261C3D), const Color(0xFF141622)]
              : [const Color(0xFF282828), const Color(0xFF1E1E1E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isPremium ? Colors.greenAccent.withValues(alpha: 0.35) : Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                planName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isPremium ? Colors.amber.withValues(alpha: 0.2) : Colors.white12,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  isPremium ? 'ACTIVE' : 'FREE TIER',
                  style: TextStyle(
                    color: isPremium ? Colors.amber : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            planDescription,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 13,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onUpgradePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium ? Colors.white12 : Colors.white,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                elevation: 0,
              ),
              child: Text(
                isPremium ? 'Manage Subscription' : 'Upgrade to Premium',
                style: TextStyle(
                  color: isPremium ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}