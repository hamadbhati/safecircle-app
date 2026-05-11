import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../guardian/guardian_dashboard.dart';
import '../child/child_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final auth = context.read<AuthService>();
    await auth.loadUser();
    if (!mounted) return;
    if (auth.currentUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } else if (auth.userModel?.role == 'guardian') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GuardianDashboard()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChildHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)],
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 50),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut).fadeIn(),
            const SizedBox(height: 24),
            const Text('SafeCircle', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2))
                .animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
            const SizedBox(height: 8),
            const Text('by Datanura AI', style: TextStyle(fontSize: 14, color: Colors.white54))
                .animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: AppTheme.primary).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
