import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/data/firebase_auth_repo.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_state.dart';
import 'package:social_media/feature/home/presentation/pages/home_page.dart';
import 'package:social_media/feature/post/data/firebase_post.repo.dart';
import 'package:social_media/feature/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/feature/profile/data/firebase_profile_repo.dart';
import 'package:social_media/feature/profile/presentation/cubits/profile_cubit.dart';

import 'feature/auth/presentation/pages/auth_page.dart';
import 'themes/light_mode.dart';

/*
App - root level
-------------------------------
Repositories: for the database
  - firebase

Bloc Providers: for state managerment
  - auth
  - profile
  - post
  - search
  - theme

Check Auth Site
  - unauthenticated -> auth page (login/register)
  - authenticated -> home page
*/

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepo();
  final profileRepo = FirebaseProfileRepo();
  final postRepo = FirebasePostRepo();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          // auth cubit
          BlocProvider(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
          ),
          
          // profile cubit
          BlocProvider(
              create: (context) => ProfileCubit(profileRepo: profileRepo)),
          
          // post cubit
          BlocProvider(create: (context) => PostCubit(postRepo: postRepo))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          home:
              BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
            print("AuthState ---- ${authState}");
            if (authState is Unauthenticated || authState is AuthError) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            }
            // loading..
            else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }, listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          }),
        ));
  }
}
