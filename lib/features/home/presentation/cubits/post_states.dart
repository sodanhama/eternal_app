import 'package:eternal_app/features/home/domain/entities/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostsLoaded extends PostState { 
  final List<Post> posts;
  final Map<String,int> commentCounts;
  PostsLoaded(this.posts, {required this.commentCounts});
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostCreated extends PostState {

}

class PostDeleted extends PostState {

}