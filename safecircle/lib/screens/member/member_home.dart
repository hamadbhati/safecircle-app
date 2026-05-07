import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';
import 'join_family_screen.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({super.key});

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> {
  bool _isConnected = false;
  bool _trackingEnabled = true;
  String _guardianName = '';
  int _trustScore = 85;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _isConnected ? _buildConnectedView() : _buildNotConnectedView(),
          ),
        ),
      ),
    );
  }

  Widget _buildNotConnectedView() {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentBlue.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.shield_rounded, size: 50, color: Colors.white),
        ).animate().fadeIn().scale(),

        const SizedBox(height: 32),

        Text(
          'SafeCircle',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = AppTheme.primaryGradient
                  .createShader(const Rect.fromLTWH(0, 0, 200, 60)),
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 8),

        Text(
          AppStrings.isUrdu
              ? 'Abhi kisi family se connect nahi hain'
              : 'Not connected to any family yet',
          style: TextStyle(color: AppTheme.grey),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 48),

        // Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentBlue.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.accentBlue, size: 32),
              const SizedBox(height: 12),
              Text(
                AppStrings.isUrdu ? 'Kaise Kaam Karta Hai?' : 'How does it work?',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _InfoStep(
                number: '1',
                text: AppStrings.isUrdu
                    ? 'Guardian se invite code lo'
                    : 'Get invite code from your guardian',
              ),
              _InfoStep(
                number: '2',
                text: AppStrings.isUrdu
                    ? 'Neeche Join button dabao'
                    : 'Tap Join button below',
              ),
              _InfoStep(
                number: '3',
                text: AppStrings.isUrdu
                    ? 'Code dalo aur connect ho jao'
                    : 'Enter code and get connected',
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 32),

        // Join Button
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JoinFamilyScreen()),
              );
              if (result != null) {
                setState(() {
                  _isConnected = true;
                  _guardianName = result;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                AppStrings.joinFamily,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 40),

        Text(
          'Powered by Datanura AI',
          style: TextStyle(color: AppTheme.grey, fontSize: 11),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildConnectedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.isUrdu ? 'Aapka SafeCircle' : 'Your SafeCircle',
                  style: TextStyle(color: AppTheme.grey, fontSize: 13),
                ),
                Text(
                  AppStrings.isUrdu ? 'Connected ✅' : 'Connected ✅',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_rounded, color: AppTheme.success, size: 28),
            ),
          ],
        ).animate().fadeIn(),

        const SizedBox(height: 24),

        // Trust Score Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.accentBlue.withOpacity(0.3), AppTheme.accentPurple.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(
                AppStrings.trustScore,
                style: TextStyle(color: AppTheme.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                '$_trustScore%',
                style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: _trustScore >= 80
                        ? AppTheme.success
                        : _trustScore >= 60
                            ? AppTheme.warning
                            : AppTheme.danger),
              ),
              Text(
                _trustScore >= 80
                    ? (AppStrings.isUrdu ? '⭐ Zabardast!' : '⭐ Excellent!')
                    : AppStrings.isUrdu
                        ? 'Acha chal raha hai'
                        : 'Keep it up!',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 20),

        // Tracking Toggle
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.track_changes_rounded, color: AppTheme.accentBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.isUrdu ? 'Tracking' : 'Tracking',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      _trackingEnabled
                          ? (AppStrings.isUrdu ? 'Chalu hai' : 'Active')
                          : (AppStrings.isUrdu ? 'Band hai' : 'Paused'),
                      style: TextStyle(
                          fontSize: 12,
                          color: _trackingEnabled ? AppTheme.success : AppTheme.grey),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _trackingEnabled,
                onChanged: (val) => setState(() => _trackingEnabled = val),
                activeColor: AppTheme.accentBlue,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        // Guardian Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.mediumBg,
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Text('👨', style: TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.isUrdu ? 'Aapka Guardian' : 'Your Guardian',
                      style: TextStyle(color: AppTheme.grey, fontSize: 12),
                    ),
                    Text(
                      _guardianName.isNotEmpty ? _guardianName : 'Guardian',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(AppStrings.online,
                    style: TextStyle(color: AppTheme.success, fontSize: 12)),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 16),

        // SOS Button
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: AppTheme.cardBg,
                title: Text(
                  AppStrings.isUrdu ? 'SOS Alert' : 'SOS Alert',
                  style: const TextStyle(color: Colors.white),
                ),
                content: Text(
                  AppStrings.isUrdu
                      ? 'Kya aap guardian ko emergency alert bhejna chahte hain?'
                      : 'Do you want to send emergency alert to your guardian?',
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppStrings.cancel,
                        style: TextStyle(color: AppTheme.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.isUrdu
                              ? 'SOS alert bhej diya gaya!'
                              : 'SOS alert sent!'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    },
                    child: const Text('SOS', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sos_rounded, color: AppTheme.danger, size: 24),
                const SizedBox(width: 8),
                Text(
                  AppStrings.isUrdu ? 'Emergency SOS' : 'Emergency SOS',
                  style: TextStyle(
                      color: AppTheme.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 500.ms),

        const SizedBox(height: 32),

        Center(
          child: Text('Powered by Datanura AI',
              style: TextStyle(color: AppTheme.grey, fontSize: 11)),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }
}

class _InfoStep extends StatelessWidget {
  final String number;
  final String text;

  const _InfoStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
