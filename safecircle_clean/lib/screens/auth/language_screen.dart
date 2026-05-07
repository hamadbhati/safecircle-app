import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  void _selectLanguage(BuildContext context, bool urdu) {
    AppStrings.isUrdu = urdu;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Shield Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: const Icon(Icons.shield_rounded, size: 40, color: Colors.white),
                ).animate().fadeIn().scale(),

                const SizedBox(height: 32),

                Text(
                  'Choose Language',
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(delay: 200.ms),

                Text(
                  'Zaban Chunein',
                  style: TextStyle(fontSize: 16, color: AppTheme.grey),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 48),

                // English Option
                _LanguageCard(
                  flag: '🇬🇧',
                  language: 'English',
                  subtitle: 'Continue in English',
                  onTap: () => _selectLanguage(context, false),
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0),

                const SizedBox(height: 16),

                // Roman Urdu Option
                _LanguageCard(
                  flag: '🇵🇰',
                  language: 'Roman Urdu',
                  subtitle: 'Roman Urdu mein jaari rahein',
                  onTap: () => _selectLanguage(context, true),
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.3, end: 0),

                const SizedBox(height: 48),

                Text(
                  'Datanura AI',
                  style: TextStyle(
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String language;
  final String subtitle;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.flag,
    required this.language,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.mediumBg),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: AppTheme.grey),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: AppTheme.accentBlue, size: 16),
          ],
        ),
      ),
    );
  }
}
