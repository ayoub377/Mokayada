import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';


class FirebaseService {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference categories = FirebaseFirestore.instance.collection(
      "Categories");
  final CollectionReference products = FirebaseFirestore.instance.collection(
      "Products");
  final storageRef = FirebaseStorage.instance.ref();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

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
          FirebaseFirestore.instance.collection('Users')
              .doc(value.user?.uid)
              .set({
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


  Future<void> SignOut() async {
    firebaseAuth.signOut();
  }

  Future<void> Google_handle_signIn() async {
    // hold the instance of the authenticated user
    User? user;
    // flag to check whether we're signed in already
    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await firebaseAuth.currentUser!;
    }
    else {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      user = (await firebaseAuth.signInWithCredential(credential)).user;
    }
  }

  Future<void> updateProfile(String name, String email, XFile image) async {
    User? user = firebaseAuth.currentUser;
    user!.updateDisplayName(name);
    user.updateEmail(email);
    user.updatePhotoURL(image.path);
    FirebaseFirestore.instance.collection('Users')
        .doc(user.uid)
        .update({
      'name': name,
      'email': email,
      'image': image.path,
    });
  }


  Future<QuerySnapshot<Map<String,dynamic>>?> Get_last_five_prods(name) async {
    var last_five_prods = await products.where("category", isEqualTo:name).orderBy('date', descending: true).limit(5).get() as  QuerySnapshot<Map<String,dynamic>>?;
    return last_five_prods;
  }

  Future<QuerySnapshot<Map<String,dynamic>>?>Get_prods(name) async {
    var prods = await products.where("category", isEqualTo:name).orderBy('date', descending: true).get() as QuerySnapshot<Map<String,dynamic>>?;
    return prods;
  }

  Future<QuerySnapshot<Map<String,dynamic>>?>Get_prods_mokayada(name) async {
    var prods = await products.where("category", isEqualTo:name,).where("isMokayada", isEqualTo: true).get() as QuerySnapshot<Map<String,dynamic>>?;
    return prods;
  }

  Future<QuerySnapshot<Map<String,dynamic>>?>Get_prods_achat(name) async {
    var prods = await products.where("category", isEqualTo:name).where("isMokayada", isEqualTo: false).get() as QuerySnapshot<Map<String,dynamic>>?;
    return prods;
  }

}