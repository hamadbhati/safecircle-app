import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';
import 'invite_member_screen.dart';
import 'member_detail_screen.dart';
import 'alerts_screen.dart';

class GuardianDashboard extends StatefulWidget {
  const GuardianDashboard({super.key});

  @override
  State<GuardianDashboard> createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends State<GuardianDashboard> {
  int _currentIndex = 0;

  // Demo members data
  final List<Map<String, dynamic>> _members = [
    {
      'name': 'Ahmed (Beta)',
      'status': 'online',
      'trustScore': 85,
      'location': 'School',
      'lastSeen': 'Abhi',
      'alert': 'normal',
      'avatar': '👦',
    },
    {
      'name': 'Sara (Beti)',
      'status': 'offline',
      'trustScore': 92,
      'location': 'Ghar',
      'lastSeen': '2 ghante pehle',
      'alert': 'normal',
      'avatar': '👧',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const AlertsScreen();
      case 2:
        return _buildLocationTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
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
                    AppStrings.isUrdu ? 'Assalam Alaikum!' : 'Welcome Back!',
                    style: TextStyle(color: AppTheme.grey, fontSize: 14),
                  ),
                  Text(
                    'SafeCircle',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = AppTheme.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 200, 40),
                        ),
                    ),
                  ),
                ],
              ),
              // Alert Bell
              Stack(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    icon: Icon(Icons.notifications_rounded,
                        color: AppTheme.accentBlue, size: 28),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(),

          const SizedBox(height: 24),

          // Stats Row
          Row(
            children: [
              _StatCard(
                title: AppStrings.isUrdu ? 'Members' : 'Members',
                value: '${_members.length}',
                icon: Icons.people_rounded,
                color: AppTheme.accentBlue,
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: AppStrings.isUrdu ? 'Alerts' : 'Alerts',
                value: '2',
                icon: Icons.warning_rounded,
                color: AppTheme.warning,
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: AppStrings.isUrdu ? 'Theek' : 'Safe',
                value: '${_members.where((m) => m['alert'] == 'normal').length}',
                icon: Icons.check_circle_rounded,
                color: AppTheme.success,
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Family Members
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.familyMembers,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InviteMemberScreen()),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.addMember,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 16),

          // Members List
          ..._members.asMap().entries.map((entry) {
            final member = entry.value;
            return _MemberCard(
              member: member,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MemberDetailScreen(member: member),
                ),
              ),
            ).animate().fadeIn(delay: (400 + entry.key * 100).ms).slideY(begin: 0.2, end: 0);
          }),

          const SizedBox(height: 24),

          // Recent Alerts
          Text(
            AppStrings.isUrdu ? 'Haaliya Alerts' : 'Recent Alerts',
            style: Theme.of(context).textTheme.titleLarge,
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 12),

          _AlertTile(
            title: AppStrings.isUrdu
                ? 'Ahmed ne raat 11 baje phone use kiya'
                : 'Ahmed used phone at 11 PM',
            time: '11:30 PM',
            level: 'caution',
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 8),

          _AlertTile(
            title: AppStrings.isUrdu
                ? 'Sara school se bahar gayi'
                : 'Sara left school zone',
            time: '3:45 PM',
            level: 'danger',
          ).animate().fadeIn(delay: 800.ms),

          const SizedBox(height: 24),

          // Datanura AI Footer
          Center(
            child: Text(
              'Powered by Datanura AI',
              style: TextStyle(fontSize: 11, color: AppTheme.grey),
            ),
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }

  Widget _buildLocationTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_rounded, size: 80, color: AppTheme.accentBlue),
          const SizedBox(height: 16),
          Text(
            AppStrings.isUrdu ? 'Live Location' : 'Live Location',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            AppStrings.isUrdu
                ? 'Google Maps integration aayegi'
                : 'Google Maps integration coming',
            style: TextStyle(color: AppTheme.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(AppStrings.settings,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          _SettingsTile(
            icon: Icons.language,
            title: AppStrings.isUrdu ? 'Zaban' : 'Language',
            subtitle: AppStrings.isUrdu ? 'Roman Urdu' : 'English',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            title: AppStrings.isUrdu ? 'Notifications' : 'Notifications',
            subtitle: AppStrings.isUrdu ? 'Sab on hain' : 'All enabled',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.security_rounded,
            title: AppStrings.isUrdu ? 'Privacy' : 'Privacy',
            subtitle: AppStrings.isUrdu ? 'Settings' : 'Settings',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.info_rounded,
            title: AppStrings.isUrdu ? 'Baray Mein' : 'About',
            subtitle: 'SafeCircle v1.0 by Datanura AI',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Text('Datanura AI',
                    style: TextStyle(
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text('Advanced Intelligence • Unified Systems',
                    style: TextStyle(color: AppTheme.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: Border(top: BorderSide(color: AppTheme.mediumBg)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.transparent,
        selectedItemColor: AppTheme.accentBlue,
        unselectedItemColor: AppTheme.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            label: AppStrings.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.warning_rounded),
            label: AppStrings.alerts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_on_rounded),
            label: AppStrings.location,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title,
                style: TextStyle(fontSize: 11, color: AppTheme.grey),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOnline = member['status'] == 'online';
    final alertColor = member['alert'] == 'danger'
        ? AppTheme.danger
        : member['alert'] == 'caution'
            ? AppTheme.warning
            : AppTheme.success;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: alertColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.mediumBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(member['avatar'],
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isOnline ? AppTheme.success : AppTheme.grey,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.cardBg, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12, color: AppTheme.accentBlue),
                      const SizedBox(width: 2),
                      Text(member['location'],
                          style:
                              TextStyle(fontSize: 12, color: AppTheme.grey)),
                      const SizedBox(width: 8),
                      Text('• ${member['lastSeen']}',
                          style:
                              TextStyle(fontSize: 12, color: AppTheme.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: alertColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${member['trustScore']}%',
                    style: TextStyle(
                        color: alertColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios,
                    color: AppTheme.grey, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final String title;
  final String time;
  final String level;

  const _AlertTile(
      {required this.title, required this.time, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = level == 'danger'
        ? AppTheme.danger
        : level == 'caution'
            ? AppTheme.warning
            : AppTheme.success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            level == 'danger'
                ? Icons.error_rounded
                : Icons.warning_amber_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 13, color: Colors.white)),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: AppTheme.grey)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentBlue, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                  Text(subtitle,
                      style:
                          TextStyle(fontSize: 12, color: AppTheme.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.grey, size: 14),
          ],
        ),
      ),
    );
  }
}
