import 'dart:convert';

import 'package:social_media/feature/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;
  final List<String> followers;
  final List<String> following;

  ProfileUser(
      {required super.uid,
      required super.email,
      required super.name,
      required this.bio,
      required this.profileImageUrl,
      required this.followers,
      required this.following});

  // mehtod to update profile user
  ProfileUser copyWith({
    String? newBio,
    String? newProdileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    return ProfileUser(
        uid: super.uid,
        email: email,
        name: name,
        bio: newBio ?? bio,
        profileImageUrl: newProdileImageUrl ?? profileImageUrl,
        followers: newFollowers ?? followers,
        following: newFollowing ?? following);
  }

  // Convert json -> profile user
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "profileImageUrl": profileImageUrl,
      "followers": followers,
      "following": following
    };
  }

  // Convert profile user -> json
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
        uid: json["uid"],
        email: json["email"],
        name: json['name'],
        bio: json['bio'] ?? "",
        profileImageUrl: json['profileImageUrl'] ?? "",
        followers: List<String>.from(json['followers'] ?? []),
        following: List<String>.from(json['following'] ?? []),
    );
  }
}
