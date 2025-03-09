import 'package:cloud_firestore/cloud_firestore.dart';
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
}
