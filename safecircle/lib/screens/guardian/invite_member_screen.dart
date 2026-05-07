import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';
import 'dart:math';

class InviteMemberScreen extends StatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  State<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends State<InviteMemberScreen> {
  String? _generatedCode;
  bool _codeCopied = false;

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(6, (i) => chars[random.nextInt(chars.length)]).join();
    return 'SC-$code';
  }

  void _generate() {
    setState(() {
      _generatedCode = _generateCode();
      _codeCopied = false;
    });
  }

  void _copyCode() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      setState(() => _codeCopied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.isUrdu ? 'Code copy ho gaya!' : 'Code copied!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: AppTheme.accentBlue),
                ),

                const SizedBox(height: 16),

                Text(
                  AppStrings.addMember,
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn(),

                const SizedBox(height: 8),

                Text(
                  AppStrings.isUrdu
                      ? 'Neeche code banayein aur member ko bhejein'
                      : 'Generate a code and share it with your member',
                  style: TextStyle(color: AppTheme.grey),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 48),

                // Steps
                _StepTile(
                  number: '1',
                  title: AppStrings.isUrdu ? 'Code Banayein' : 'Generate Code',
                  subtitle: AppStrings.isUrdu
                      ? 'Neeche button dabayein'
                      : 'Tap the button below',
                ).animate().fadeIn(delay: 200.ms),

                _StepTile(
                  number: '2',
                  title: AppStrings.isUrdu ? 'Code Share Karein' : 'Share Code',
                  subtitle: AppStrings.isUrdu
                      ? 'Member ko WhatsApp ya SMS karein'
                      : 'Send via WhatsApp or SMS',
                ).animate().fadeIn(delay: 300.ms),

                _StepTile(
                  number: '3',
                  title: AppStrings.isUrdu ? 'Member Join Kare' : 'Member Joins',
                  subtitle: AppStrings.isUrdu
                      ? 'Member app mein code daale'
                      : 'Member enters code in their app',
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                // Code Display
                if (_generatedCode != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentBlue.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.inviteCode,
                          style: TextStyle(color: AppTheme.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _generatedCode!,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentCyan,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.codeExpiry,
                          style: TextStyle(color: AppTheme.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _copyCode,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.mediumBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _codeCopied ? Icons.check : Icons.copy,
                                        color: AppTheme.accentBlue,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _codeCopied
                                            ? (AppStrings.isUrdu ? 'Copy hua!' : 'Copied!')
                                            : (AppStrings.isUrdu ? 'Copy Karein' : 'Copy'),
                                        style: TextStyle(color: AppTheme.accentBlue),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Share functionality
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.share, color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppStrings.isUrdu ? 'Share' : 'Share',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale(),

                  const SizedBox(height: 20),
                ],

                // Generate Button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _generate,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: Text(
                        _generatedCode == null
                            ? AppStrings.generateCode
                            : (AppStrings.isUrdu ? 'Naya Code Banayein' : 'Generate New Code'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _StepTile({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: AppTheme.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
