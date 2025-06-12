import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user?.sendEmailVerification();
      showToasts(message: "Email verifikasi wes dikirim, cek inboxmu!!!");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // print("Some error occured");
      if (e.code == 'email-already-in-use') {
        showToasts(message: 'The email address is already in use.');
      } else {
        showToasts(message: 'An error occured: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // print("Some error occured");
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToasts(message: 'Invalid email or password');
      } else {
        showToasts(message: 'An error occured ${e.code}');
      }
    }
    return null;
  }

  Future<bool> isEmailVerified() async {
    User? user = _auth.currentUser;
    await user
        ?.reload(); // ini sebenenrya biar tau udah diverify atau engga, ambil data terbaru
    return user?.emailVerified ?? false;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      final userDoc = _firestore.collection('users').doc(user!.uid);
      final cek = await userDoc.get();

      if (!cek.exists) {
        await userDoc.set({
          'username': user.displayName ?? 'CHANGE ME',
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      showToasts(message: 'Login dengan Google failedd: ${e.message}');
    }
    return null;
  }
}
