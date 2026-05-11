import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../guardian/guardian_dashboard.dart';
import '../child/child_home.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'guardian';
  bool _loading = false;

  Future<void> _signup() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) return;
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final error = await auth.signUp(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      name: _nameCtrl.text.trim(),
      role: _role,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: AppTheme.danger));
      return;
    }
    if (_role == 'guardian') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GuardianDashboard()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChildHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(title: const Text('Register'), backgroundColor: AppTheme.darkBg),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account Banayein', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Apna role chunein', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _roleCard('guardian', '👨‍👩‍👧', 'Guardian', 'Parents ke liye')),
                const SizedBox(width: 12),
                Expanded(child: _roleCard('child', '👦', 'Child', 'Bachon ke liye')),
              ],
            ),
            const SizedBox(height: 24),
            _field(_nameCtrl, 'Naam', Icons.person_outline),
            const SizedBox(height: 14),
            _field(_emailCtrl, 'Email', Icons.email_outlined),
            const SizedBox(height: 14),
            _field(_passCtrl, 'Password', Icons.lock_outline, obscure: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _signup,
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(String role, String emoji, String title, String subtitle) {
    final selected = _role == role;
    return GestureDetector(
      onTap: () => setState(() => _role = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary.withOpacity(0.2) : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppTheme.primary : Colors.white12, width: selected ? 2 : 1),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: AppTheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
