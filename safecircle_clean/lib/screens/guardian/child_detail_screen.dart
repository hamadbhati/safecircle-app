import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/family_service.dart';
import '../../theme/app_theme.dart';
import 'app_blocker_screen.dart';
import 'live_location_screen.dart';

class ChildDetailScreen extends StatefulWidget {
  final UserModel child;
  const ChildDetailScreen({super.key, required this.child});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<AppUsageModel> _appUsage = [];
  bool _loadingUsage = true;
  bool _requestingScreenshot = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUsage();
  }

  Future<void> _loadUsage() async {
    final usage = await context.read<FamilyService>().getAppUsage(widget.child.uid, DateTime.now());
    setState(() { _appUsage = usage; _loadingUsage = false; });
  }

  Future<void> _requestScreenshot() async {
    setState(() => _requestingScreenshot = true);
    await context.read<FamilyService>().requestScreenshot(widget.child.uid);
    setState(() => _requestingScreenshot = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Screenshot request bhej diya!'), backgroundColor: AppTheme.success));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        title: Text(widget.child.name),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: Colors.white54,
          tabs: const [Tab(text: 'Overview'), Tab(text: 'App Usage'), Tab(text: 'Activity')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_overviewTab(), _appUsageTab(), _activityTab()],
      ),
    );
  }

  Widget _overviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary.withOpacity(0.3), AppTheme.cardBg]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppTheme.primary.withOpacity(0.3),
                  child: Text(widget.child.name[0].toUpperCase(), style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.child.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('Child Account', style: TextStyle(color: Colors.white54)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('🟢 Active', style: TextStyle(color: AppTheme.success, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _actionBtn(Icons.location_on, 'Live Location', AppTheme.secondary, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => LiveLocationScreen(child: widget.child)));
              })),
              const SizedBox(width: 12),
              Expanded(child: _actionBtn(
                Icons.screenshot_monitor,
                _requestingScreenshot ? 'Sending...' : 'Screenshot',
                AppTheme.warning,
                _requestingScreenshot ? null : _requestScreenshot,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _actionBtn(Icons.block, 'App Blocker', AppTheme.danger, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AppBlockerScreen(child: widget.child)));
              })),
              const SizedBox(width: 12),
              Expanded(child: _actionBtn(Icons.bar_chart, 'Full Report', AppTheme.primary, () {
                _tabController.animateTo(1);
              })),
            ],
          ),
          const SizedBox(height: 24),
          const Align(alignment: Alignment.centerLeft, child: Text('Aaj ki Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
          const SizedBox(height: 12),
          Row(
            children: [
              _miniStat('Screen Time', '2h 34m', Icons.phone_android, AppTheme.primary),
              const SizedBox(width: 12),
              _miniStat('Apps Used', '${_appUsage.length}', Icons.apps, AppTheme.secondary),
              const SizedBox(width: 12),
              _miniStat('Alerts', '0', Icons.warning_amber, AppTheme.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appUsageTab() {
    if (_loadingUsage) return const Center(child: CircularProgressIndicator());
    if (_appUsage.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.apps, size: 64, color: Colors.white24),
        const SizedBox(height: 16),
        const Text('Aaj ka data nahi mila', style: TextStyle(color: Colors.white54)),
      ]));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('App Usage - Aaj', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        ..._appUsage.map((usage) => _usageCard(usage)),
      ],
    );
  }

  Widget _activityTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Recent Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        _activityItem(Icons.phone, 'Call Log', '5 calls aaj', AppTheme.primary),
        _activityItem(Icons.message, 'Messages', '23 messages', AppTheme.secondary),
        _activityItem(Icons.location_on, 'Location', 'Last updated 5 min ago', AppTheme.success),
        _activityItem(Icons.photo_camera, 'Screenshots', '2 screenshots', AppTheme.warning),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _miniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _usageCard(AppUsageModel usage) {
    final percent = (usage.usageMinutes / 480).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(usage.appName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${usage.usageMinutes} min', style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: percent, backgroundColor: Colors.white12, color: AppTheme.primary, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _activityItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ]),
      ]),
    );
  }
}
