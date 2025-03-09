import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/auth/domain/entities/app_user.dart';
import 'package:social_media/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media/feature/post/domain/entities/post.dart';
import 'package:social_media/feature/post/presentation/cubits/post_cubit.dart';
import 'package:social_media/feature/post/presentation/cubits/post_states.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final textController = TextEditingController();
  final imageUrlController = TextEditingController();

  // current user
  AppUser? currentUser;

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  @override
  void initState() {
    super.initState();
    // get current user
    getCurrentUser();
  }

  void uploadPost() {
    final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser!.uid,
        userName: currentUser!.name,
        text: textController.text,
        imageUrl: imageUrlController.text,
        timestamp: DateTime.now(),
        likes: []);

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      if (state is PostsLoading) {
        return Scaffold(
          body: Center(
              child: Column(
            children: [CircularProgressIndicator()],
          )),
        );
      } else {
        return uploadPage();
      }
    }, listener: (context, state) {
      if (state is PostsLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget uploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create post"),
        actions: [
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey))),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(
                    hintText: "What's your image?",
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
