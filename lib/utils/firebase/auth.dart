import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/utils/backgroundService/service.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';
import 'package:vivarium_control_unit/utils/firebase/googleAuth/googleAuth.dart';
import 'package:vivarium_control_unit/utils/firebase/messagingService.dart';

class Auth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final DatabaseService _dbService = DatabaseService();

  static Stream<VivariumUser?> get userStream {
    return _firebaseAuth
        .authStateChanges()
        .map((User? user) => _parseFromFirebaseUser(user));
  }

  static VivariumUser get user {
    var user = _firebaseAuth.currentUser;
    return _parseFromFirebaseUser(user);
  }

  static VivariumUser _parseFromFirebaseUser(User? user) {
    return VivariumUser(
        userId: user?.uid,
        imageUrl: user?.photoURL,
        userEmail: user?.email,
        userName: user?.displayName);
  }

  /// Credentials created from google sign in method
  Future<VivariumUser> signInWithCredentialObj(Credentials? credentials) async {
    if (credentials == null) return _parseFromFirebaseUser(null);
    try {
      final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
              accessToken: credentials.accessToken,
              idToken: credentials.idToken));
      final user = authResult.user!;

      /// Initialize new user
      if (user.metadata.creationTime == user.metadata.lastSignInTime) {
        _dbService.onNewUser(user.uid);
      }
      return _parseFromFirebaseUser(user);
    } catch (e) {
      debugPrint('signInWithCredentialObj' + e.toString());
      return _parseFromFirebaseUser(null);
    }
  }

  Future<VivariumUser> registerWithEmailPassword(
      {required String email, required String password}) async {
    try {
      var userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      /// Initialize new user
      _dbService.onNewUser(userCredentials.user!.uid);
      return _parseFromFirebaseUser(userCredentials.user);
    } catch (e) {
      debugPrint('registerWithEmailPassword' + e.toString());
      return _parseFromFirebaseUser(null);
    }
  }

  Future<VivariumUser> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = authResult.user;
      return _parseFromFirebaseUser(user);
    } catch (e) {
      debugPrint('signInWithEmailAndPassword' + e.toString());
      return _parseFromFirebaseUser(null);
    }
  }

  Future<void> signOut() async {
    try {
      var t = await MessagingService.getToken();
      if (t != null)
        await _dbService.deleteFCMToken(
            userId: _firebaseAuth.currentUser!.uid, token: t);

      await _firebaseAuth.signOut();
      await googleAuth.signOut();
    } catch (e) {
      debugPrint('signOut' + e.toString());
    }
  }

  Future<void> onUserLoggedIn(String userId) async {
    try {
      await _dbService.setFCMToken(
          userId: userId,
          token: await (MessagingService.getToken() as FutureOr<String>));
      await MessagingService.requestPermission();
      if (await FlutterBackgroundService().isServiceRunning()) {
        BackgroundService.sendUserId(userId);
      }
    } catch (e) {
      debugPrint('onUserLoggedIn' + e.toString());
    }
  }
}
