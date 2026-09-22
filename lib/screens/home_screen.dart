import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/home/header_greeting.dart';
import '../widgets/home/category_filter.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

@override
    Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderGreetingWidget(salam: 'Selamat Datang'),
              const SizedBox(height: 8),
              CategoryFilter(
                onSelected: (category) {

                },
              ),
              const SizedBox(height: 16),
            ],
            ),
          ),
        )
    );
    }
}