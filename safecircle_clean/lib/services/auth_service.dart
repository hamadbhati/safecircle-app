import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  Future<void> loadUser() async {
    if (_auth.currentUser == null) return;
    final doc = await _db.collection('users').doc(_auth.currentUser!.uid).get();
    if (doc.exists) {
      _userModel = UserModel.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: cred.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );
      await _db.collection('users').doc(cred.user!.uid).set(user.toMap());
      _userModel = user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loadUser();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _userModel = null;
    notifyListeners();
  }
}
