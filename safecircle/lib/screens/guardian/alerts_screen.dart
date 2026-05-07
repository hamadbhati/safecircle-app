import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  final List<Map<String, dynamic>> _alerts = const [
    {
      'title': 'Suspicious keyword detected',
      'titleUrdu': 'Shak wala lafz milا',
      'desc': 'Ahmed typed a suspicious word in WhatsApp',
      'descUrdu': 'Ahmed ne WhatsApp mein ganda lafz type kiya',
      'time': '11:45 PM',
      'level': 'danger',
      'member': 'Ahmed',
      'icon': '💬',
    },
    {
      'title': 'Left safe zone',
      'titleUrdu': 'Safe ilaqe se bahar gaya',
      'desc': 'Sara left school zone at 3:45 PM',
      'descUrdu': 'Sara school se 3:45 PM par bahar gayi',
      'time': '3:45 PM',
      'level': 'danger',
      'member': 'Sara',
      'icon': '📍',
    },
    {
      'title': 'Late night usage',
      'titleUrdu': 'Raat ko phone use',
      'desc': 'Ahmed used phone after 11 PM',
      'descUrdu': 'Ahmed ne raat 11 baje baad phone use kiya',
      'time': '11:30 PM',
      'level': 'caution',
      'member': 'Ahmed',
      'icon': '🌙',
    },
    {
      'title': 'New app installed',
      'titleUrdu': 'Nai app install hui',
      'desc': 'Sara installed a new app: "Yubo"',
      'descUrdu': 'Sara ne nai app install ki: "Yubo"',
      'time': '5:00 PM',
      'level': 'caution',
      'member': 'Sara',
      'icon': '📲',
    },
    {
      'title': 'Arrived home safely',
      'titleUrdu': 'Ghar pohonch gaya',
      'desc': 'Ahmed entered home safe zone',
      'descUrdu': 'Ahmed ghar wapas aa gaya',
      'time': '4:30 PM',
      'level': 'normal',
      'member': 'Ahmed',
      'icon': '🏠',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(AppStrings.alerts,
              style: Theme.of(context).textTheme.headlineMedium)
              .animate().fadeIn(),
          const SizedBox(height: 4),
          Text(
            AppStrings.isUrdu ? 'Aaj ki tamam sargarmiyaan' : 'All alerts for today',
            style: TextStyle(color: AppTheme.grey),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          // Alert counts
          Row(
            children: [
              _AlertCount(count: '2', label: AppStrings.isUrdu ? 'Khatarnak' : 'Danger', color: AppTheme.danger),
              const SizedBox(width: 12),
              _AlertCount(count: '2', label: AppStrings.isUrdu ? 'Dhyan Dein' : 'Caution', color: AppTheme.warning),
              const SizedBox(width: 12),
              _AlertCount(count: '1', label: AppStrings.isUrdu ? 'Theek' : 'Normal', color: AppTheme.success),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Alert list
          ..._alerts.asMap().entries.map((entry) {
            final alert = entry.value;
            final color = alert['level'] == 'danger'
                ? AppTheme.danger
                : alert['level'] == 'caution'
                    ? AppTheme.warning
                    : AppTheme.success;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon circle
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(alert['icon'], style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppStrings.isUrdu ? alert['titleUrdu'] : alert['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                    fontSize: 14),
                              ),
                            ),
                            Text(alert['time'],
                                style: TextStyle(color: AppTheme.grey, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.isUrdu ? alert['descUrdu'] : alert['desc'],
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.mediumBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            alert['member'],
                            style: TextStyle(color: AppTheme.accentBlue, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (300 + entry.key * 80).ms).slideY(begin: 0.2, end: 0);
          }),
        ],
      ),
    );
  }
}

class _AlertCount extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _AlertCount({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(count,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: TextStyle(fontSize: 11, color: color),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
