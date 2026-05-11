import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/family_service.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final familyId = auth.userModel?.familyId;
    if (familyId == null) {
      return const Center(child: Text('Family setup nahi hai', style: TextStyle(color: Colors.white54)));
    }
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(backgroundColor: AppTheme.darkBg, title: const Text('Alerts')),
      body: StreamBuilder<List<AlertModel>>(
        stream: context.read<FamilyService>().getAlerts(familyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final alerts = snapshot.data ?? [];
          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('Koi alert nahi', style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, i) => _alertCard(context, alerts[i]),
          );
        },
      ),
    );
  }

  Widget _alertCard(BuildContext context, AlertModel alert) {
    Color color;
    IconData icon;
    switch (alert.type) {
      case 'keyword': color = AppTheme.danger; icon = Icons.warning; break;
      case 'night_use': color = AppTheme.warning; icon = Icons.nightlight; break;
      case 'screenshot': color = AppTheme.primary; icon = Icons.screenshot_monitor; break;
      case 'daily_report': color = AppTheme.success; icon = Icons.bar_chart; break;
      default: color = Colors.white54; icon = Icons.notifications;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: alert.isRead ? AppTheme.cardBg : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: alert.isRead ? Colors.white12 : color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(alert.childName, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(_timeAgo(alert.timestamp), style: const TextStyle(color: Colors.white38, fontSize: 11)),
              if (!alert.isRead)
                IconButton(
                  icon: const Icon(Icons.check, size: 18, color: Colors.white54),
                  onPressed: () => context.read<FamilyService>().markAlertRead(alert.id),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(alert.message, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          if (alert.screenshotUrl != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(alert.screenshotUrl!, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Abhi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min pehle';
    if (diff.inHours < 24) return '${diff.inHours} ghante pehle';
    return '${diff.inDays} din pehle';
  }
}
