import 'package:social_media/feature/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
  });

  // mehtod to update profile user
  ProfileUser copyWith({
    String? newBio,
    String? newProdileImageUrl,
  }) {
    return ProfileUser(
      uid: super.uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProdileImageUrl ?? profileImageUrl,
    );
  }

  // Convert json -> profile user
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "profileImageUrl": profileImageUrl,
    };
  }

  // Convert profile user -> json
  factory ProfileUser.fromJson(Map<String, dynamic> jsonUser) {
    return ProfileUser(
      uid: jsonUser["uid"],
      email: jsonUser["email"],
      name: jsonUser['name'],
      bio: jsonUser['bio'] ?? "",
      profileImageUrl: jsonUser['profileImageUrl'] ?? "",
    );
  }
}
