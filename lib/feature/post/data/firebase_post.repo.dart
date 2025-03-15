import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/feature/post/domain/entities/comment.dart';
import 'package:social_media/feature/post/domain/entities/post.dart';
import 'package:social_media/feature/post/domain/repos/post.repos.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Store the post in a collection called 'post'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      print("Error creating post: $e");
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();
      final userPost = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userPost;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }

  @override
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      // get the post document from firestore
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        // check if user has already like this post
        final hasLiked = post.likes.contains(userId);
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await postsCollection.doc(postId).update({'likes': post.likes});
      } else {
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error toggling like: @e");
    }
  }

  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      // get post comment
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert to json
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.add(comment);

        // update the post document in firestore
        await postsCollection.doc(postId).update(
            {'comments': post.comments.map((comment) => comment.toJson())});
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      // get post comment
      final postDoc = await postsCollection.doc(postId).get();

      if (postDoc.exists) {
        // convert to json
        final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

        //add the new comment
        post.comments.removeWhere((comment) => comment.id == commentId);

        // update the post document in firestore
        await postsCollection.doc(postId).update(
            {'comments': post.comments.map((comment) => comment.toJson())});
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }
}
