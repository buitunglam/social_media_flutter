

import 'package:social_media/feature/post/domain/entities/post.dart';

abstract class PostState{}

// initial state
class PostsInitial extends PostState{}

//loading
class PostsLoading extends PostState{}

// uploading
class PostUploading extends PostState{}

// error
class PostsError extends PostState {
  final String message;
  PostsError(this.message);
}

// loaded
class PostsLoaded extends PostState {
  final List<Post> posts;
  PostsLoaded(this.posts);
}
