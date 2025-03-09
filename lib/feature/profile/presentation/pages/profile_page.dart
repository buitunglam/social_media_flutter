import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media/feature/profile/presentation/components/bio_box.dart';
import 'package:social_media/feature/profile/presentation/cubits/profile_cubit.dart';
import 'package:social_media/feature/profile/presentation/cubits/profile_state.dart';
import 'package:social_media/feature/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // cubit
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

// on start up
  @override
  void initState() {
    super.initState();
    print("initial---");
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    // cubits
    late final authCubit = context.read<AuthCubit>();
    // current user
    late AppUser? currentUser = authCubit.currentUser;

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      // loaded
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(user.name),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage(user: user)));
                  },
                  icon: Icon(Icons.settings))
            ],
          ),
          body: Column(
            children: [
              Center(
                child: Text(
                  user.email,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(25),
                width: 120,
                height: 120,
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(
                height: 25,
              ),
              // bio
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  children: [
                    Text(
                      "Bio",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              BioBox(text: user.bio),

              Padding(
                padding: const EdgeInsets.only(left: 25, top: 25),
                child: Row(
                  children: [
                    Text(
                      "Post",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
      // loading
      else if (state is ProfileLoading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      // no profile
      else {
        return Center(
          child: Text("No profile found!!!"),
        );
      }
    });
  }
}
