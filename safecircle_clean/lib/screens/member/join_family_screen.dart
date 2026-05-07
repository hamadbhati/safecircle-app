import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _joinFamily() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.isUrdu ? 'Code dalein' : 'Please enter code'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // Demo: any code works
    Navigator.pop(context, 'Guardian');
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
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: AppTheme.accentBlue),
                ),

                const SizedBox(height: 32),

                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(Icons.link_rounded, size: 40, color: Colors.white),
                  ).animate().fadeIn().scale(),
                ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    AppStrings.joinFamily,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).animate().fadeIn(delay: 200.ms),
                ),

                Center(
                  child: Text(
                    AppStrings.isUrdu
                        ? 'Guardian ka bheja hua code dalein'
                        : 'Enter the code sent by your guardian',
                    style: TextStyle(color: AppTheme.grey),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms),
                ),

                const SizedBox(height: 48),

                TextField(
                  controller: _codeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentCyan,
                      letterSpacing: 4),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'SC-XXXXXX',
                    hintStyle: TextStyle(color: AppTheme.grey, fontSize: 20, letterSpacing: 2),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _joinFamily,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              AppStrings.joinFamily,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
