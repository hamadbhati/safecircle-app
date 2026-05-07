import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_strings.dart';

class MemberDetailScreen extends StatefulWidget {
  final Map<String, dynamic> member;
  const MemberDetailScreen({super.key, required this.member});

  @override
  State<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _appUsage = [
    {'app': 'WhatsApp', 'icon': '💬', 'time': '2s 30m', 'minutes': 150},
    {'app': 'Instagram', 'icon': '📸', 'time': '1s 45m', 'minutes': 105},
    {'app': 'TikTok', 'icon': '🎵', 'time': '1s 10m', 'minutes': 70},
    {'app': 'YouTube', 'icon': '▶️', 'time': '45m', 'minutes': 45},
    {'app': 'Chrome', 'icon': '🌐', 'time': '30m', 'minutes': 30},
    {'app': 'Telegram', 'icon': '✈️', 'time': '20m', 'minutes': 20},
    {'app': 'Snapchat', 'icon': '👻', 'time': '15m', 'minutes': 15},
  ];

  final List<Map<String, dynamic>> _callLogs = [
    {'name': 'Ali Bhai', 'number': '+92-300-1234567', 'type': 'incoming', 'duration': '5m 20s', 'time': '10:30 AM'},
    {'name': 'Unknown', 'number': '+92-333-9876543', 'type': 'outgoing', 'duration': '2m 10s', 'time': '1:15 PM'},
    {'name': 'Ammi', 'number': '+92-321-1111111', 'type': 'incoming', 'duration': '8m 45s', 'time': '4:00 PM'},
    {'name': 'Unknown', 'number': '+92-312-5555555', 'type': 'missed', 'duration': '-', 'time': '9:00 PM'},
  ];

  final List<Map<String, dynamic>> _websites = [
    {'url': 'youtube.com', 'visits': 12, 'safe': true},
    {'url': 'google.com', 'visits': 8, 'safe': true},
    {'url': 'instagram.com', 'visits': 6, 'safe': true},
    {'url': 'unknown-site.com', 'visits': 2, 'safe': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final trustScore = member['trustScore'] as int;
    final trustColor = trustScore >= 80
        ? AppTheme.success
        : trustScore >= 60
            ? AppTheme.warning
            : AppTheme.danger;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios, color: AppTheme.accentBlue),
                        ),
                        const Spacer(),
                        Text(
                          AppStrings.isUrdu ? 'Tafseel' : 'Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Member Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: trustColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Avatar
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppTheme.mediumBg,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(member['avatar'],
                                      style: const TextStyle(fontSize: 28)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 14, color: AppTheme.accentBlue),
                                        const SizedBox(width: 4),
                                        Text(member['location'],
                                            style: TextStyle(
                                                color: AppTheme.grey, fontSize: 13)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Trust Score
                              Column(
                                children: [
                                  Text(
                                    AppStrings.trustScore,
                                    style: TextStyle(color: AppTheme.grey, fontSize: 11),
                                  ),
                                  Text(
                                    '$trustScore%',
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: trustColor),
                                  ),
                                  Text(
                                    trustScore >= 80
                                        ? AppStrings.excellent
                                        : trustScore >= 60
                                            ? AppStrings.good
                                            : AppStrings.needsAttention,
                                    style: TextStyle(
                                        color: trustColor, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Screen Time Summary
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.mediumBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _InfoChip(
                                  label: AppStrings.screenTime,
                                  value: '6s 45m',
                                  icon: Icons.phone_android,
                                ),
                                _InfoChip(
                                  label: AppStrings.isUrdu ? 'Calls' : 'Calls',
                                  value: '4',
                                  icon: Icons.call,
                                ),
                                _InfoChip(
                                  label: AppStrings.isUrdu ? 'Apps' : 'Apps',
                                  value: '7',
                                  icon: Icons.apps,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(),
                  ],
                ),
              ),

              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.accentBlue,
                labelColor: AppTheme.accentBlue,
                unselectedLabelColor: AppTheme.grey,
                tabs: [
                  Tab(text: AppStrings.isUrdu ? 'Apps' : 'Apps'),
                  Tab(text: AppStrings.isUrdu ? 'Calls' : 'Calls'),
                  Tab(text: AppStrings.isUrdu ? 'Web' : 'Web'),
                  Tab(text: AppStrings.isUrdu ? 'AI Report' : 'AI Report'),
                ],
              ),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppUsageTab(),
                    _buildCallLogsTab(),
                    _buildWebsitesTab(),
                    _buildAIReportTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppUsageTab() {
    final maxMinutes = _appUsage.map((a) => a['minutes'] as int).reduce((a, b) => a > b ? a : b);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _appUsage.length,
      itemBuilder: (context, index) {
        final app = _appUsage[index];
        final ratio = (app['minutes'] as int) / maxMinutes;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(app['icon'], style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(app['app'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                  Text(app['time'],
                      style: TextStyle(color: AppTheme.accentBlue, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: AppTheme.mediumBg,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ratio > 0.7 ? AppTheme.warning : AppTheme.accentBlue,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildCallLogsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _callLogs.length,
      itemBuilder: (context, index) {
        final call = _callLogs[index];
        final isIncoming = call['type'] == 'incoming';
        final isMissed = call['type'] == 'missed';
        final color = isMissed
            ? AppTheme.danger
            : isIncoming
                ? AppTheme.success
                : AppTheme.accentBlue;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isMissed
                    ? Icons.call_missed
                    : isIncoming
                        ? Icons.call_received
                        : Icons.call_made,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(call['name'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white)),
                    Text(call['number'],
                        style: TextStyle(fontSize: 12, color: AppTheme.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(call['time'],
                      style: TextStyle(fontSize: 12, color: AppTheme.grey)),
                  Text(call['duration'],
                      style: TextStyle(fontSize: 12, color: color)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildWebsitesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _websites.length,
      itemBuilder: (context, index) {
        final site = _websites[index];
        final isSafe = site['safe'] as bool;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSafe
                  ? AppTheme.success.withOpacity(0.1)
                  : AppTheme.danger.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSafe ? Icons.check_circle : Icons.dangerous,
                color: isSafe ? AppTheme.success : AppTheme.danger,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(site['url'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              Text(
                '${site['visits']} ${AppStrings.isUrdu ? 'dafa' : 'visits'}',
                style: TextStyle(color: AppTheme.grey, fontSize: 12),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms);
      },
    );
  }

  Widget _buildAIReportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _AIReportCard(
            emoji: '📊',
            title: AppStrings.isUrdu ? 'Is Hafte Ki Summary' : 'This Week\'s Summary',
            content: AppStrings.isUrdu
                ? 'Ahmed ne is hafte average 6 ghante 45 minute phone use kiya. Yeh pichle hafte se 30 minute zyada hai.'
                : 'Ahmed used phone for an average of 6h 45m this week. This is 30 minutes more than last week.',
            color: AppTheme.accentBlue,
          ),
          const SizedBox(height: 12),
          _AIReportCard(
            emoji: '⚠️',
            title: AppStrings.isUrdu ? 'Dhyan Talab Cheezein' : 'Areas of Concern',
            content: AppStrings.isUrdu
                ? '3 raatein raat 11 baje ke baad phone use hua. TikTok ka istemal zyada ho raha hai.'
                : 'Phone used after 11 PM on 3 nights. TikTok usage is increasing significantly.',
            color: AppTheme.warning,
          ),
          const SizedBox(height: 12),
          _AIReportCard(
            emoji: '✅',
            title: AppStrings.isUrdu ? 'Achi Baatein' : 'Positive Signs',
            content: AppStrings.isUrdu
                ? 'School ke waqt phone use nahi hua. Koi bhi gandi website nahi dekhi gayi.'
                : 'No phone usage during school hours. No inappropriate websites detected.',
            color: AppTheme.success,
          ),
          const SizedBox(height: 12),
          _AIReportCard(
            emoji: '🤖',
            title: AppStrings.isUrdu ? 'AI Ki Ray' : 'AI Recommendation',
            content: AppStrings.isUrdu
                ? 'Raat 10 baje ke baad phone band karne ka waqt muqarrar karein. Ahmed se baat karein TikTok ke waqt ke baray mein.'
                : 'Set a phone bedtime at 10 PM. Have a conversation about TikTok screen time.',
            color: AppTheme.accentPurple,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('AI Report by Datanura AI',
                style: TextStyle(color: AppTheme.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.accentBlue, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        Text(label, style: TextStyle(color: AppTheme.grey, fontSize: 10)),
      ],
    );
  }
}

class _AIReportCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String content;
  final Color color;

  const _AIReportCard({
    required this.emoji,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
        ],
      ),
    ).animate().fadeIn();
  }
}
