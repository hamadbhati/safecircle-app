import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/family_service.dart';
import '../../theme/app_theme.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  String? _inviteLink;
  bool _loading = false;

  Future<void> _generateLink() async {
    setState(() => _loading = true);
    final family = context.read<FamilyService>();
    final link = await family.createFamilyAndGetInviteLink();
    setState(() {
      _inviteLink = link;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: const Text('Child ko Invite Karein'), backgroundColor: AppTheme.darkBg),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.info_outline, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    const Text('Kaise Kaam Karta Hai', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 12),
                  _step('1', 'Neeche "Link Generate Karein" button dabayein'),
                  _step('2', 'Link WhatsApp se apne bachy ko bhejein'),
                  _step('3', 'Bacha link tap karega aur app install karega'),
                  _step('4', 'App install hone ke baad aap connect ho jayenge'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_inviteLink == null)
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _generateLink,
                  icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.link),
                  label: Text(_loading ? 'Generating...' : 'Link Generate Karein'),
                ),
              )
            else ...[
              const Text('Invite Link', style: TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.secondary.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(_inviteLink!, style: const TextStyle(color: AppTheme.secondary, fontSize: 13))),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.white54),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _inviteLink!));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copy ho gaya!'), backgroundColor: AppTheme.success));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Share.share('🛡️ SafeCircle App mein join ho jao!\n\nYe link use karo:\n$_inviteLink\n\n- Datanura AI', subject: 'SafeCircle Invite'),
                  icon: const Icon(Icons.share),
                  label: const Text('WhatsApp se Bhejein'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _generateLink,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Naya Link Banayein'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _step(String num, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22, height: 22,
            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
            child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13))),
        ],
      ),
    );
  }
}
