import 'package:eternal_app/features/home/domain/entities/comment.dart';
import 'package:eternal_app/features/home/domain/entities/post.dart';

abstract class PostRepo {
  Future<void> createPost(Post post);
  Future<void> deletePost(String id);
  Future<List<Post>> loadAllPosts();

  Future<void> addComment(Comment comment);
  Future<void> deleteComment(String postId, String commentId);
  Future<List<Comment>> getComments(String postId);
}