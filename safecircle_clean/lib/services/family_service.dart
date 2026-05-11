import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class FamilyService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<UserModel> _children = [];
  List<UserModel> get children => _children;
  String? _familyId;
  String? get familyId => _familyId;

  Future<String> createFamilyAndGetInviteLink() async {
    final uid = _auth.currentUser!.uid;
    final familyId = const Uuid().v4();
    _familyId = familyId;
    await _db.collection('families').doc(familyId).set({
      'guardianId': uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'members': [],
    });
    await _db.collection('users').doc(uid).update({'familyId': familyId});
    final inviteToken = const Uuid().v4().substring(0, 8).toUpperCase();
    await _db.collection('invites').doc(inviteToken).set({
      'familyId': familyId,
      'guardianId': uid,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'used': false,
    });
    notifyListeners();
    return 'https://safecircle.app/join/$inviteToken';
  }

  Future<String?> joinFamily(String inviteToken) async {
    try {
      final token = inviteToken.split('/').last.toUpperCase();
      final inviteDoc = await _db.collection('invites').doc(token).get();
      if (!inviteDoc.exists) return 'Invalid invite link';
      if (inviteDoc.data()!['used'] == true) return 'Invite already used';
      final familyId = inviteDoc.data()!['familyId'];
      final uid = _auth.currentUser!.uid;
      await _db.collection('users').doc(uid).update({'familyId': familyId});
      await _db.collection('families').doc(familyId).update({
        'members': FieldValue.arrayUnion([uid]),
      });
      await _db.collection('invites').doc(token).update({'used': true});
      _familyId = familyId;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> loadChildren(String familyId) async {
    _familyId = familyId;
    final familyDoc = await _db.collection('families').doc(familyId).get();
    if (!familyDoc.exists) return;
    final memberIds = List<String>.from(familyDoc.data()!['members'] ?? []);
    _children = [];
    for (final memberId in memberIds) {
      final userDoc = await _db.collection('users').doc(memberId).get();
      if (userDoc.exists) {
        _children.add(UserModel.fromMap(userDoc.data()!));
      }
    }
    notifyListeners();
  }

  Stream<LocationModel?> getChildLocation(String childId) {
    return _db.collection('locations').doc(childId).snapshots()
        .map((doc) => doc.exists ? LocationModel.fromMap(doc.data()!) : null);
  }

  Stream<List<AlertModel>> getAlerts(String familyId) {
    return _db.collection('alerts')
        .where('familyId', isEqualTo: familyId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map((d) => AlertModel.fromMap(d.data())).toList());
  }

  Future<List<AppUsageModel>> getAppUsage(String childId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final snap = await _db.collection('app_usage')
        .where('childId', isEqualTo: childId)
        .where('date', isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
        .where('date', isLessThan: endOfDay.millisecondsSinceEpoch)
        .get();
    return snap.docs.map((d) => AppUsageModel.fromMap(d.data())).toList();
  }

  Future<void> toggleAppBlock(String childId, String packageName, bool block) async {
    await _db.collection('app_blocks').doc('${childId}_$packageName').set({
      'childId': childId,
      'packageName': packageName,
      'blocked': block,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<String>> getBlockedApps(String childId) async {
    final snap = await _db.collection('app_blocks')
        .where('childId', isEqualTo: childId)
        .where('blocked', isEqualTo: true)
        .get();
    return snap.docs.map((d) => d.data()['packageName'] as String).toList();
  }

  Future<void> requestScreenshot(String childId) async {
    await _db.collection('screenshot_requests').doc(childId).set({
      'childId': childId,
      'requestedAt': DateTime.now().millisecondsSinceEpoch,
      'status': 'pending',
    });
  }

  Future<void> markAlertRead(String alertId) async {
    await _db.collection('alerts').doc(alertId).update({'isRead': true});
  }
}
