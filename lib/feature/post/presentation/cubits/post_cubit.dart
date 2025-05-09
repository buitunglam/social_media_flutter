import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/feature/post/domain/entities/comment.dart';
import 'package:social_media/feature/post/domain/entities/post.dart';
import 'package:social_media/feature/post/domain/repos/post.repos.dart';
import 'package:social_media/feature/post/presentation/cubits/post_states.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;

  PostCubit({
    required this.postRepo,
  }) : super(PostsInitial());

  // creqate post
  Future<void> createPost(Post post) async {
    try {
      emit(PostUploading());
      await postRepo.createPost(post);
      fetchAllPosts();
    } catch (e) {
      emit(PostsError("Error creating post: $e"));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Error fetching posts: $e"));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      emit(PostsLoading());
      postRepo.deletePost(postId);
    } catch (e) {
      emit(PostsError("Error fetching posts: $e"));
    }
  }

  // toggle like post
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      // fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  }

  // add a comment to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  // delete a comment in a post
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to delete comment: $e"));
    }
  }
}
