import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/feature/profile/domain/entities/profile_user.dart';
import 'package:social_media/feature/profile/domain/repos/profile.repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        print("userData ----${userData}");
        if (userData != null) {
          return ProfileUser(
              uid: uid,
              email: userData["email"],
              name: userData["name"],
              bio: userData["bio"] ?? "",
              profileImageUrl: userData["profileImageUrl"] ?? "");
        }

        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updateProfile) async {
    try {
      await firebaseFirestore
          .collection("users")
          .doc(updateProfile.uid)
          .update({
        "bio": updateProfile.bio,
        "profileImageUrl": updateProfile.profileImageUrl
      });
      print("success ---");
    } catch (e) {
      print("error --$e");
      throw Exception(e);
    }
  }
}
