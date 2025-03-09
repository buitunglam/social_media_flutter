import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    // no user logged in
    if (firebaseUser == null) {
      return null;
    }
    // user exist
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection('users').doc(firebaseUser.uid).get();
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: userDoc['name'],
    );
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document from firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      // create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid, email: email, name: userDoc['name']);
      print("user login: $user");
      
      
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      // save user data in firestore
      firebaseFirestore.collection("users").doc(user.uid).set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
