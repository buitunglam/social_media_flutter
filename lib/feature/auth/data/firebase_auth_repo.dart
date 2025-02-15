import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;
    // no user logged in
    if (firebaseUser == null) {
      return null;
    }
    // user exist
    return AppUser(uid: firebaseUser.uid, email: firebaseUser.email!, name: "");
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // TODO: implement loginWithEmailPassword
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      // create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: "");
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String email, String password) async {
    try {
      // TODO: implement loginWithEmailPassword
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      // create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: "");
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
