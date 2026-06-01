import 'package:eternal_app/features/home/domain/entities/comment.dart';
import 'package:eternal_app/features/home/domain/repos/post_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eternal_app/features/home/presentation/cubits/post_states.dart';
import 'package:eternal_app/features/home/domain/entities/post.dart';


class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;

  PostCubit({required this.postRepo}) : super(PostInitial());


  List<Post> _posts = []; 

  List<Post> get posts => _posts;

  Future<void> loadPosts() async {
    try {
      emit(PostLoading());
      _posts = await postRepo.loadAllPosts();
  
      final Map<String,int> commentCounts = {};

      for (final post in _posts) {
        final comments = await postRepo.getComments(post.id);
        commentCounts[post.id] = comments.length;
      }

      emit(PostsLoaded(posts, commentCounts:commentCounts));
    } catch (e) {
      emit(PostError(e.toString()));
    }    
  }

  Future<void> createPost({
    required String title,
    required String content,
    required String category,
    required String username,
  }) async {
    try {
      emit(PostLoading());
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        category: category,
        username: username
      );
      await postRepo.createPost(post);
      emit(PostCreated());
      await loadPosts();
    } catch (e) {
      emit(PostError(e.toString()));  

    }
  }

  Future<void> deletePost(String id) async {
    try {
      emit(PostLoading());
      await postRepo.deletePost(id);
      emit(PostDeleted());
      await loadPosts();

    }
    catch(e) {
      emit(PostError(e.toString()));

    }
  }
  
  Future<List<Comment>> getComments(String postId) async {
    try {
      return await postRepo.getComments(postId);
    }

    catch(e) {
      emit(PostError(e.toString()));
      return [];
    }
  } 

  Future<void> addComment({
    required String postId,
    required String text,
    required String username,
  }) async {
    try{
      final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: postId,
        text: text,
        username: username
      );

      await postRepo.addComment(comment);
      await loadPosts();
    }
    catch(e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> deleteComment({required String commentId, required String postId}) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await loadPosts();

    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}