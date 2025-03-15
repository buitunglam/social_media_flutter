import 'package:social_media/feature/post/domain/entities/comment.dart';
import 'package:social_media/feature/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fetchAllPosts();
  Future<void> createPost(Post post);
  Future<List<Post>> fetchPostsByUserId(String userId);
  Future<void> deletePost(String postId);
  Future<void> toggleLikePost(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
