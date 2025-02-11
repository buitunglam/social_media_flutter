import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  @override
  Future<AppUser?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> registerWithEmailPassword(String email, String password) {
    // TODO: implement registerWithEmailPassword
    throw UnimplementedError();
  }
}
