import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class MonitoringService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Timer? _locationTimer;
  Timer? _reportTimer;
  Timer? _nightAlertTimer;

  String? _childId;
  String? _familyId;
  String? _childName;

  void initialize(String childId, String familyId, String childName) {
    _childId = childId;
    _familyId = familyId;
    _childName = childName;
    _startLocationTracking();
    _startNightAlertCheck();
    _listenForScreenshotRequests();
    _startDailyReportScheduler();
  }

  void _startLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      await _updateLocation();
    });
    _updateLocation();
  }

  Future<void> _updateLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final location = LocationModel(
        lat: position.latitude,
        lng: position.longitude,
        timestamp: DateTime.now(),
      );
      await _db.collection('locations').doc(_childId).set(location.toMap());
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _startNightAlertCheck() {
    _nightAlertTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      final now = DateTime.now();
      if (now.hour >= AppConstants.nightAlertHour && now.hour < 5) {
        await _sendAlert(
          type: 'night_use',
          message: '🌙 $_childName raat ${now.hour}:${now.minute.toString().padLeft(2, '0')} baje phone use kar raha hai!',
        );
      }
    });
  }

  void _listenForScreenshotRequests() {
    _db.collection('screenshot_requests').doc(_childId).snapshots().listen((doc) async {
      if (!doc.exists) return;
      final data = doc.data()!;
      if (data['status'] == 'pending') {
        await _sendAlert(type: 'screenshot', message: '📸 Guardian ne screenshot request kiya');
        await doc.reference.update({'status': 'done'});
      }
    });
  }

  Future<void> checkTextForBadContent(String text, String source) async {
    final lowerText = text.toLowerCase();
    for (final keyword in AppConstants.badKeywords) {
      if (lowerText.contains(keyword)) {
        final isHarmful = await _analyzeWithGemini(text, source);
        if (isHarmful) {
          await _sendAlert(
            type: 'keyword',
            message: '⚠️ $_childName ne "$keyword" word use kiya - $source mein galat content!',
          );
        }
        break;
      }
    }
  }

  Future<bool> _analyzeWithGemini(String text, String source) async {
    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/${AppConstants.geminiModel}:generateContent?key=${AppConstants.geminiApiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{'parts': [{'text': 'Is this text harmful, sexual, violent, or drug-related? Text: "$text" Reply ONLY: YES or NO'}]}]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['candidates'][0]['content']['parts'][0]['text'].toString().trim().toUpperCase();
        return answer.contains('YES');
      }
    } catch (e) {
      debugPrint('Gemini error: $e');
    }
    return false;
  }

  void _startDailyReportScheduler() {
    _reportTimer = Timer.periodic(const Duration(hours: 1), (_) async {
      final now = DateTime.now();
      if (now.hour == AppConstants.dailyReportHour && now.minute < 5) {
        await _generateAndSendDailyReport();
      }
    });
  }

  Future<void> _generateAndSendDailyReport() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastReport = prefs.getString('last_report_date') ?? '';
      final today = DateTime.now().toIso8601String().substring(0, 10);
      if (lastReport == today) return;
      final usageSnap = await _db.collection('app_usage')
          .where('childId', isEqualTo: _childId)
          .where('date', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch - 86400000)
          .get();
      String reportText = '📊 $_childName ki aaj ki report:\n\n';
      if (usageSnap.docs.isEmpty) {
        reportText += 'Koi app usage data nahi mila.';
      } else {
        for (final doc in usageSnap.docs) {
          final usage = AppUsageModel.fromMap(doc.data());
          reportText += '${usage.appName}: ${usage.usageMinutes} minutes\n';
        }
      }
      await _sendAlert(type: 'daily_report', message: reportText);
      await prefs.setString('last_report_date', today);
    } catch (e) {
      debugPrint('Daily report error: $e');
    }
  }

  Future<void> _sendAlert({required String type, required String message, String? screenshotUrl}) async {
    final alertId = const Uuid().v4();
    final alert = AlertModel(
      id: alertId,
      type: type,
      message: message,
      screenshotUrl: screenshotUrl,
      timestamp: DateTime.now(),
      childId: _childId!,
      childName: _childName!,
    );
    await _db.collection('alerts').doc(alertId).set({
      ...alert.toMap(),
      'familyId': _familyId,
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _reportTimer?.cancel();
    _nightAlertTimer?.cancel();
    super.dispose();
  }
}
