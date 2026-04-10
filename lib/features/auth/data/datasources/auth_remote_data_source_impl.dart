import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:olshopapp/features/auth/domain/entities/user.dart';


abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User> signInWithGoogle();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(credential.user!, null);
    } on firebase.FirebaseAuthException catch (e) {
      debugPrint("Firebase error: ${e.code}");
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred during login');
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      return _mapFirebaseUser(credential.user!, name);
    } on firebase.FirebaseAuthException catch (e) {
      debugPrint("Firebase error: ${e.code}");
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred during registration');
    }
  }

  Exception _handleFirebaseAuthException(firebase.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Incorrect password.');
      case 'invalid-email':
        return Exception('Invalid email address.');
      case 'user-disabled':
        return Exception('This user account has been disabled.');
      case 'email-already-in-use':
        return Exception('This email is already registered.');
      case 'weak-password':
        return Exception('Password is too weak.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'invalid-credential':
        return Exception('Invalid email or password.');
      default:
        return Exception(e.message ?? 'An error occurred during authentication');
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    // 7.x.x uses authenticate() instead of signIn()
    final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
    if (googleUser == null) throw Exception('Google sign in cancelled');

    // googleUser.authentication is now synchronous in 7.x.x
    final googleAuth = googleUser.authentication;
    
    // Request scopes to get the access token in 7.x.x
    final authorization = await googleUser.authorizationClient.authorizeScopes([
      'email',
      'profile',
    ]);

    final credential = firebase.GoogleAuthProvider.credential(
      accessToken: authorization.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    return _mapFirebaseUser(userCredential.user!, null);
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (_) {}
    
    try {
      await googleSignIn.signOut();
    } catch (_) {}
  }

  User _mapFirebaseUser(firebase.User firebaseUser, String? name) {
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? name ?? '',
    );
  }
}
