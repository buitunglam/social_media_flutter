/*

Auth state 

*/

import 'package:social_media/feature/auth/domain/entities/app_user.dart';

abstract class AuthState {}

// initial state
class AuthInitial extends AuthState {}

//loading
class AuthLoading extends AuthState {}

// authenticated
class Authenticated extends AuthState {
  final AppUser user;
  Authenticated({required this.user});
}

// unauthenticated
class Unauthenticated extends AuthState {}

// errors
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}