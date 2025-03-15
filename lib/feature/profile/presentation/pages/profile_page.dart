import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media/feature/post/components/post_tile.dart';
import 'package:social_media/feature/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/feature/post/presentation/cubits/post_states.dart';
import 'package:social_media/feature/profile/presentation/components/bio_box.dart';
import 'package:social_media/feature/profile/presentation/components/follow_button.dart';
import 'package:social_media/feature/profile/presentation/components/profile_starts.dart';
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
  // current user
  late AppUser? currentUser = authCubit.currentUser;

  // on start up
  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  // post
  int postCount = 0;

  /*
    FOLLOW?UNFOLLOW
  */
  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    // optimistic update ui
    setState(() {
      // unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }
      // follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.add(currentUser!.uid);
        }
        // follow
        else {
          profileUser.followers.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      // loaded
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        print("isfollowing ----${user.followers.contains(currentUser!.uid)}");
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(user.name),
            ),
            actions: [
              // edit button
              if (isOwnPost)
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user: user)));
                    },
                    icon: Icon(Icons.settings))
            ],
          ),
          body: ListView(
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
                height: 10,
              ),

              // profile starts
              ProfileStarts(
                  postCount: postCount,
                  followerCount: user.followers.length,
                  followingCount: user.following.length),

              SizedBox(
                height: 20,
              ),

              // folow button
              if (!isOwnPost)
                FollowButton(
                    onPressed: followButtonPressed,
                    isFollowing: user.followers.contains(currentUser!.uid)),

              SizedBox(
                height: 25,
              ),

              // bio
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
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
              SizedBox(
                height: 10,
              ),
              // list of post
              BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                if (state is PostsLoaded) {
                  // filter posts by user id
                  final userPosts = state.posts
                      .where((post) => post.userId == widget.uid)
                      .toList();
                  postCount = userPosts.length;

                  return ListView.builder(
                    itemCount: postCount,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // get individual post
                      final post = userPosts[index];
                      // return as post tile UI
                      return PostTile(
                          post: post,
                          onDeletePressed: () =>
                              context.read<PostCubit>().deletePost(post.id));
                    },
                  );
                }

                // post loading
                else if (state is PostsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Text("No post..."),
                  );
                }
              })
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
