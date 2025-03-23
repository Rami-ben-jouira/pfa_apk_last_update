import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error log out in: $e");
      return;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error registering user: $e");
      rethrow; // Rethrow the exception to handle it in the UI
    }
  }

  Stream<User?> authState() {
    Stream<User?> user = FirebaseAuth.instance.authStateChanges();
    return user;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Error sending password reset email: $e");
      return false;
    }
  }

  Future<void> sendVerificationEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  
  if (user != null && !user.emailVerified) {
    await user.sendEmailVerification();
  }
}
  Future<bool> checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.reload();
    User? user = FirebaseAuth.instance.currentUser;

    return user?.emailVerified ?? false;
  }
}
