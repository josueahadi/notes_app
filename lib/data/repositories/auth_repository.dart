import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please check your internet connection and try again.';
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please check your internet connection and try again.';
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address. Please check your email or sign up for a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address. Please sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      case 'invalid-email':
        return 'Invalid email address format. Please enter a valid email.';
      case 'invalid-credential':
        return 'The email or password is incorrect. Please check your credentials and try again.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a moment before trying again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support for assistance.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection and try again.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }
}
