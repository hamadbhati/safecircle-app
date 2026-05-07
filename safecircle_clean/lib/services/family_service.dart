import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class FamilyService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _familyId;
  String? get familyId => _familyId;

  // Generate invite code and save to Firestore
  Future<String> generateInviteCode() async {
    final user = _auth.currentUser;
    if (user == null) return '';

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = List.generate(6, (i) => chars[random.nextInt(chars.length)]).join();
    final fullCode = 'SC-$code';

    // Save code to Firestore with 24hr expiry
    await _firestore.collection('invite_codes').doc(fullCode).set({
      'guardianId': user.uid,
      'guardianName': user.displayName ?? 'Guardian',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
      'used': false,
    });

    return fullCode;
  }

  // Join family using invite code
  Future<Map<String, dynamic>?> joinWithCode(String code) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final codeDoc = await _firestore.collection('invite_codes').doc(code).get();

      if (!codeDoc.exists) return {'error': 'Code nahi mila'};

      final data = codeDoc.data()!;

      // Check if expired
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();
      if (DateTime.now().isAfter(expiresAt)) {
        return {'error': 'Code expire ho gaya. Naya code mangein.'};
      }

      // Check if already used
      if (data['used'] == true) {
        return {'error': 'Yeh code pehle use ho chuka hai.'};
      }

      final guardianId = data['guardianId'];
      final guardianName = data['guardianName'];

      // Create family connection
      final familyRef = await _firestore.collection('families').add({
        'guardianId': guardianId,
        'members': [user.uid],
        'createdAt': FieldValue.serverTimestamp(),
      });

      _familyId = familyRef.id;

      // Update member record
      await _firestore.collection('users').doc(user.uid).update({
        'familyId': familyRef.id,
        'guardianId': guardianId,
        'role': 'member',
      });

      // Mark code as used
      await _firestore.collection('invite_codes').doc(code).update({'used': true});

      notifyListeners();
      return {'success': true, 'guardianName': guardianName};
    } catch (e) {
      return {'error': 'Masla hua. Dobara try karein.'};
    }
  }

  // Get family members for guardian
  Stream<List<Map<String, dynamic>>> getFamilyMembers() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('families')
        .where('guardianId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Save activity data for member
  Future<void> saveActivity(Map<String, dynamic> activity) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('activities')
        .doc(user.uid)
        .collection('daily')
        .add({
      ...activity,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Send alert to guardian
  Future<void> sendAlert({
    required String memberId,
    required String guardianId,
    required String alertType,
    required String message,
    required String level,
  }) async {
    await _firestore.collection('alerts').add({
      'memberId': memberId,
      'guardianId': guardianId,
      'type': alertType,
      'message': message,
      'level': level,
      'read': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get alerts for guardian
  Stream<List<Map<String, dynamic>>> getAlerts() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('alerts')
        .where('guardianId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }
}
