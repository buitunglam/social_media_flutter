import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/home/presentation/components/my_drawer.dart';
import 'package:social_media/feature/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/feature/post/presentation/cubits/post_states.dart';
import 'package:social_media/feature/post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // post cubit
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Home")),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadPostPage()))
                  },
              icon: Icon(Icons.add)),
        ],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading
          if (state is PostsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No posts available"),
              );
            }

            return ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  // image
                  debugPrint("Image URL: ${post.imageUrl}");
                  return CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    height: 430,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(height: 430),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  );
                });
          } else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
