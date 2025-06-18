import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/global/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email,
      String password,
      String username,) async {
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

  Future<User?> signInWithEmailAndPassword(String email,
      String password,) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await synchronizeUserData();
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
      await synchronizeUserData();
      return user;
    } on FirebaseAuthException catch (e) {
      showToasts(message: 'Login dengan Google failedd: ${e.message}');
    }
    return null;
  }

  // Ini buat ambil data user dari firestore
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        showToasts(message: "Error getting user data: $e");
      }
    }
    return null;
  }

  // Ini buat update username di firestore
  Future<void> updateUsername(String newUsername) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'username': newUsername});
        showToasts(message: "Username successfully updated!");
      } catch (e) {
        showToasts(message: "Error updating username: $e");
      }
    }
  }

  // Update email di firebase dan firestore
  Future<void> updateUserEmail(String newEmail) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.verifyBeforeUpdateEmail(newEmail);
        // await user.updateEmail(newEmail);
        // await _firestore
        //     .collection('users')
        //     .doc(user.uid)
        //     .update({'email': newEmail});
        // showToasts(message: "Email berhasil diupdate, silahkan login lagi!!.");
        showToasts(message: "Link verifikasi telah dikirim ke $newEmail. Silakan cek inbox untuk menyelesaikan perubahan.");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          showToasts(
              message:
              "Update email gagal, silahkan logout, login, dan coba lagi!");
        } else {
          showToasts(message: "Error update email: ${e.message}");
        }
      }
    }
  }

  // Untuk update password
  Future<void> updateUserPassword(String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        showToasts(
            message: "Password berhasil diupdate");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          showToasts(
              message:
              "Update password gagal, silahkan logout, login, dan coba lagi!");
        } else {
          showToasts(message: "Error update password: ${e.message}");
        }
      }
    }
  }

  // Untuk cek is user login via Google
  Future<bool> isGoogleSignIn() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }

    for (final provider in user.providerData) {
      if (provider.providerId == 'google.com') {
        return true;
      }
    }

    return false;
  }

  // Cek data firestore dah sama dengan firebase ga
  Future<void> synchronizeUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      await user.reload();
      user = _auth.currentUser;
      if (user == null) return;
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userDocSnap = await userDocRef.get();

      if (userDocSnap.exists) {
        final firestoreEmail = userDocSnap.data()?['email'];

        if (user.email != null && user.email != firestoreEmail) {
          // kalo beda, berarti email telah berhasil diverifikasi.
          await userDocRef.update({'email': user.email});
          print("Firestore email synchronized dengan email login.");
        }
      }
    } catch (e) {
      showToasts(message: "Error during user data synchronization: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
