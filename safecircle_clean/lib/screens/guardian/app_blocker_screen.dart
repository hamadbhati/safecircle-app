import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/family_service.dart';
import '../../theme/app_theme.dart';

class AppBlockerScreen extends StatefulWidget {
  final UserModel child;
  const AppBlockerScreen({super.key, required this.child});

  @override
  State<AppBlockerScreen> createState() => _AppBlockerScreenState();
}

class _AppBlockerScreenState extends State<AppBlockerScreen> {
  List<String> _blockedApps = [];
  bool _loading = true;

  final List<Map<String, String>> _commonApps = [
    {'name': 'TikTok', 'package': 'com.zhiliaoapp.musically', 'emoji': '🎵'},
    {'name': 'Instagram', 'package': 'com.instagram.android', 'emoji': '📸'},
    {'name': 'YouTube', 'package': 'com.google.android.youtube', 'emoji': '▶️'},
    {'name': 'PUBG', 'package': 'com.tencent.ig', 'emoji': '🎮'},
    {'name': 'Free Fire', 'package': 'com.dts.freefireth', 'emoji': '🔥'},
    {'name': 'Snapchat', 'package': 'com.snapchat.android', 'emoji': '👻'},
    {'name': 'Facebook', 'package': 'com.facebook.katana', 'emoji': '👤'},
    {'name': 'Twitter/X', 'package': 'com.twitter.android', 'emoji': '🐦'},
    {'name': 'Chrome', 'package': 'com.android.chrome', 'emoji': '🌐'},
    {'name': 'WhatsApp', 'package': 'com.whatsapp', 'emoji': '💬'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBlockedApps();
  }

  Future<void> _loadBlockedApps() async {
    final blocked = await context.read<FamilyService>().getBlockedApps(widget.child.uid);
    setState(() { _blockedApps = blocked; _loading = false; });
  }

  Future<void> _toggleBlock(String packageName, bool currentlyBlocked) async {
    await context.read<FamilyService>().toggleAppBlock(widget.child.uid, packageName, !currentlyBlocked);
    setState(() {
      if (currentlyBlocked) { _blockedApps.remove(packageName); }
      else { _blockedApps.add(packageName); }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(currentlyBlocked ? 'App unblock ho gayi!' : 'App block ho gayi!'),
      backgroundColor: currentlyBlocked ? AppTheme.success : AppTheme.danger,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(backgroundColor: AppTheme.darkBg, title: Text('${widget.child.name} - App Blocker')),
      body: _loading ? const Center(child: CircularProgressIndicator()) : Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.warning.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
                const SizedBox(width: 10),
                const Expanded(child: Text('Block karne ke baad bacha wo app use nahi kar sakega.', style: TextStyle(color: Colors.white70, fontSize: 13))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('${_blockedApps.length} apps blocked', style: const TextStyle(color: Colors.white54, fontSize: 13)),
                const Spacer(),
                if (_blockedApps.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      for (final pkg in List.from(_blockedApps)) {
                        await context.read<FamilyService>().toggleAppBlock(widget.child.uid, pkg, false);
                      }
                      setState(() => _blockedApps.clear());
                    },
                    child: const Text('Sab Unblock', style: TextStyle(color: AppTheme.danger)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _commonApps.length,
              itemBuilder: (context, index) {
                final app = _commonApps[index];
                final isBlocked = _blockedApps.contains(app['package']);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isBlocked ? AppTheme.danger.withOpacity(0.1) : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isBlocked ? AppTheme.danger.withOpacity(0.4) : Colors.white12),
                  ),
                  child: ListTile(
                    leading: Text(app['emoji']!, style: const TextStyle(fontSize: 28)),
                    title: Text(app['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text(app['package']!, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    trailing: Switch(
                      value: isBlocked,
                      onChanged: (_) => _toggleBlock(app['package']!, isBlocked),
                      activeColor: AppTheme.danger,
                      inactiveThumbColor: AppTheme.success,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
