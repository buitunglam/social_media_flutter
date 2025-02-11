import 'package:social_media/feature/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String email, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
