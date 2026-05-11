import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/family_service.dart';
import '../../theme/app_theme.dart';

class LiveLocationScreen extends StatelessWidget {
  final UserModel child;
  const LiveLocationScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final family = context.read<FamilyService>();
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        title: Text('${child.name} - Live Location'),
      ),
      body: StreamBuilder<LocationModel?>(
        stream: family.getChildLocation(child.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 80, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('Location data nahi mila', style: TextStyle(color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Bacha app use karega tab location update hogi', style: TextStyle(color: Colors.white38, fontSize: 13), textAlign: TextAlign.center),
                ],
              ),
            );
          }
          final location = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.secondary.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(child.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          const Spacer(),
                          Text(_timeAgo(location.timestamp), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.location_pin, color: AppTheme.primary, size: 18),
                          const SizedBox(width: 8),
                          Text('Latitude: ${location.lat.toStringAsFixed(6)}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_pin, color: AppTheme.secondary, size: 18),
                          const SizedBox(width: 8),
                          Text('Longitude: ${location.lng.toStringAsFixed(6)}', style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final url = 'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lng}';
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Maps: $url')));
                          },
                          icon: const Icon(Icons.map),
                          label: const Text('Google Maps mein Dekho'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.map_outlined, size: 64, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text('${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}', style: const TextStyle(color: Colors.white54, fontSize: 16)),
                        const SizedBox(height: 8),
                        const Text('Google Maps API key add karo\nmap yahan dikhega', style: TextStyle(color: Colors.white38, fontSize: 12), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Abhi';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min pehle';
    return '${diff.inHours} ghante pehle';
  }
}
