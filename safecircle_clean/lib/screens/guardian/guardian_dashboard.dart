import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/family_service.dart';
import '../../theme/app_theme.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';
import 'invite_screen.dart';
import 'child_detail_screen.dart';
import 'alerts_screen.dart';
import 'live_location_screen.dart';

class GuardianDashboard extends StatefulWidget {
  const GuardianDashboard({super.key});

  @override
  State<GuardianDashboard> createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends State<GuardianDashboard> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthService>();
    final family = context.read<FamilyService>();
    if (auth.userModel?.familyId != null) {
      await family.loadChildren(auth.userModel!.familyId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final family = context.watch<FamilyService>();
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SafeCircle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Guardian: ${auth.userModel?.name ?? ''}', style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
        ],
      ),
      body: _tab == 0 ? _homeTab(auth, family) : _tab == 1 ? const AlertsScreen() : _settingsTab(auth),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: AppTheme.cardBg,
        indicatorColor: AppTheme.primary.withOpacity(0.3),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteScreen())),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add),
        label: const Text('Invite Child'),
      ),
    );
  }

  Widget _homeTab(AuthService auth, FamilyService family) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statCard('Connected\nChildren', '${family.children.length}', Icons.people, AppTheme.primary),
              const SizedBox(width: 12),
              _statCard('Active\nAlerts', '0', Icons.warning_amber, AppTheme.warning),
              const SizedBox(width: 12),
              _statCard('Today\'s\nReports', '1', Icons.bar_chart, AppTheme.success),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Connected Children', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          if (family.children.isEmpty) _emptyChildren() else ...family.children.map((child) => _childCard(child)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }

  Widget _emptyChildren() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.child_care, size: 64, color: AppTheme.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Koi child connected nahi', style: TextStyle(color: Colors.white54)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteScreen())),
            icon: const Icon(Icons.person_add),
            label: const Text('Invite Karen'),
          ),
        ],
      ),
    );
  }

  Widget _childCard(UserModel child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.2),
          child: Text(child.name[0].toUpperCase(), style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
        ),
        title: Text(child.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: const Text('Online', style: TextStyle(color: Colors.green, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.location_on, color: AppTheme.secondary),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveLocationScreen(child: child))),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white54),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChildDetailScreen(child: child))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTab(AuthService auth) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _settingsTile(Icons.person_outline, 'Profile', auth.userModel?.name ?? ''),
        _settingsTile(Icons.notifications_outlined, 'Notifications', 'On'),
        _settingsTile(Icons.security, 'App Version', '1.0.0'),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () async {
            await auth.signOut();
            if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}
