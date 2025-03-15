import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/profile/domain/entities/profile_user.dart';
import 'package:social_media/feature/profile/domain/repos/profile.repo.dart';
import 'package:social_media/feature/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // fetch user profile  using repo -> useFull for loading single profile pages
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // return user profile giben uid -> useFull for loading many profile for all post
  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  // update user profile
  Future<void> updateProfile({
    required String uid,
    String? newBio,
  }) async {
    emit(ProfileLoading());
    try {
      // fetch current user
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user to update profile"));
        return;
      }

      // profile updload image

      // update new profile
      final updateProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio);
      print("updateProfile ----${updateProfile.bio} -- uid: $uid");
      // update in repo
      await profileRepo.updateProfile(updateProfile);

      // fetch to update user in state
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profle: $e"));
    }
  }

  // toggle follow/unfollow
  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
      // fetchUserProfile(targetUserId);
    } catch (e) {
      emit(ProfileError('Error toggling follow: $e'));
    }
  }
}
