import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FirebaseService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference categories = FirebaseFirestore.instance.collection("Categories");
  final CollectionReference products = FirebaseFirestore.instance.collection("Products");
  final storageRef = FirebaseStorage.instance.ref();

  Future<bool> SignIn(email, password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password

      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<bool> handleSignUp(email, password, name) async {
    // hold the instance of the authenticated user
    User? user;
    // flag to check whether we're signed in already
    if (firebaseAuth.currentUser != null) {
      user = firebaseAuth.currentUser;
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        ).then((value) async {
          firebaseAuth.currentUser?.updateDisplayName(name);
          FirebaseFirestore.instance.collection('Users').doc(value.user?.uid).set({
            'name': name,
            'email': email,
            'uid': value.user?.uid,
            'image': '',
          });
        });
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
    return false;
  }


  User? GetProfileInfos() {
    User? user = firebaseAuth.currentUser;
    return user;
  }

  void SignOut() {
    firebaseAuth.signOut();
  }


}