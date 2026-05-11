import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/family_service.dart';
import '../../services/monitoring_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final _linkCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _join() async {
    if (_linkCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final family = context.read<FamilyService>();
    final auth = context.read<AuthService>();
    final error = await family.joinFamily(_linkCtrl.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppTheme.danger));
      return;
    }
    await auth.loadUser();
    if (auth.userModel?.familyId != null) {
      context.read<MonitoringService>().initialize(
        auth.userModel!.uid,
        auth.userModel!.familyId!,
        auth.userModel!.name,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guardian se connect ho gaye!'), backgroundColor: AppTheme.success));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(backgroundColor: AppTheme.darkBg, title: const Text('Family Join Karein')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.info_outline, color: AppTheme.primary),
                    SizedBox(width: 8),
                    Text('Kaise Join Karein', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                  SizedBox(height: 12),
                  Text('• Guardian ne aapko WhatsApp par ek link bheja hoga\n• Woh link neeche paste karein\n• Ya sirf code (8 letters) likhein', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Invite Link ya Code', style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _linkCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'https://safecircle.app/join/XXXXXXXX',
                  hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                  prefixIcon: const Icon(Icons.link, color: AppTheme.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _join,
                icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.group_add),
                label: Text(_loading ? 'Joining...' : 'Family Join Karein'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
