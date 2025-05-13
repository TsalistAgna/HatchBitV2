import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_mobile/global/toast.dart';

class FirebaseAuthService{

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    on FirebaseAuthException catch(e){
      // print("Some error occured");
      if (e.code == 'email-already-in-use'){
        showToasts(message: 'The email address is already in use.');
      }
      else{
        showToasts(message: 'An error occured: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    on FirebaseAuthException catch(e){
      // print("Some error occured");
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        showToasts(message: 'Invalid email or password');
      }
      else{
        showToasts(message: 'An error occured ${e.code}');
      }
    }
    return null;
  }
}