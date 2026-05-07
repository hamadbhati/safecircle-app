import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Account nahi mila. Pehle signup karein.';
        case 'wrong-password':
          return 'Password galat hai.';
        case 'invalid-email':
          return 'Email sahi nahi hai.';
        default:
          return 'Login nahi ho saka. Dobara koshish karein.';
      }
    } catch (e) {
      return 'Kuch masla hua. Dobara try karein.';
    }
  }

  Future<String?> signup(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'role': '',
      });

      await credential.user!.updateDisplayName(name);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return 'Password kam az kam 6 harf ka hona chahiye.';
        case 'email-already-in-use':
          return 'Yeh email pehle se use ho rahi hai.';
        case 'invalid-email':
          return 'Email sahi nahi hai.';
        default:
          return 'Account nahi bana. Dobara koshish karein.';
      }
    } catch (e) {
      return 'Kuch masla hua. Dobara try karein.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
