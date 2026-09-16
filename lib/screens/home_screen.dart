import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/home/header_greeting.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

@override
    Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
            HeaderGreetingWidget(salam: 'Selamat Datang'),
        ],
        ),
        ),
    );
    }
}