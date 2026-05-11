import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/monitoring_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import 'join_family_screen.dart';

class ChildHome extends StatefulWidget {
  const ChildHome({super.key});

  @override
  State<ChildHome> createState() => _ChildHomeState();
}

class _ChildHomeState extends State<ChildHome> {
  @override
  void initState() {
    super.initState();
    _initMonitoring();
  }

  Future<void> _initMonitoring() async {
    final auth = context.read<AuthService>();
    final monitoring = context.read<MonitoringService>();
    if (auth.userModel?.familyId != null) {
      monitoring.initialize(auth.userModel!.uid, auth.userModel!.familyId!, auth.userModel!.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final hasFamilyId = auth.userModel?.familyId != null;
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        title: const Text('SafeCircle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]),
              ),
              child: Center(
                child: Text(
                  (auth.userModel?.name ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(auth.userModel?.name ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('Child Account', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 32),
            if (!hasFamilyId)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
                ),
                child: Column(children: [
                  const Icon(Icons.link_off, color: AppTheme.warning, size: 48),
                  const SizedBox(height: 16),
                  const Text('Guardian se connected nahi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Guardian ka bheja hua invite link use karein', style: TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JoinFamilyScreen())),
                    icon: const Icon(Icons.link),
                    label: const Text('Invite Link Use Karein'),
                  ),
                ]),
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.success.withOpacity(0.4)),
                ),
                child: Column(children: [
                  const Icon(Icons.shield_outlined, color: AppTheme.success, size: 48),
                  const SizedBox(height: 12),
                  const Text('Guardian se Connected!', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Aapka guardian aapki safety ka khayal rakh raha hai', style: TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
                ]),
              ),
              const SizedBox(height: 24),
              Row(children: [
                _statusCard('Location', 'Active', Icons.location_on, AppTheme.secondary),
                const SizedBox(width: 12),
                _statusCard('Monitoring', 'On', Icons.visibility, AppTheme.primary),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _statusCard('Reports', 'Daily 9PM', Icons.bar_chart, AppTheme.warning),
                const SizedBox(width: 12),
                _statusCard('Protection', 'Active', Icons.security, AppTheme.success),
              ]),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kya Monitor Ho Raha Hai:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _infoRow(Icons.location_on, 'Aapki live location guardian dekh sakta hai'),
                    _infoRow(Icons.apps, 'App usage daily track hoti hai'),
                    _infoRow(Icons.report, 'Raat 9 baje guardian ko report milti hai'),
                    _infoRow(Icons.nightlight, 'Raat 12 ke baad use karne par alert'),
                    _infoRow(Icons.screenshot_monitor, 'Guardian kabhi bhi screenshot le sakta hai'),
                    _infoRow(Icons.block, 'Guardian koi bhi app block kar sakta hai'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
        ]),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(icon, color: AppTheme.primary, size: 16),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12))),
      ]),
    );
  }
}
