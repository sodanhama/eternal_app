import 'package:eternal_app/features/auth/presentation/components/my_textfield.dart';
import 'package:eternal_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:eternal_app/features/home/domain/entities/comment.dart';
import 'package:eternal_app/features/home/domain/entities/post.dart';
import 'package:eternal_app/features/home/presentation/components/comment_tile.dart';
import 'package:eternal_app/features/home/presentation/components/post_tile.dart';
import 'package:eternal_app/features/home/presentation/cubits/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;

  late final _postCubit = context.read<PostCubit>();
  late final _authCubit = context.read<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override 
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final comments = await _postCubit.getComments(widget.post.id);
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    }

    catch(e) {
      setState(() {
        _comments = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load comments: $e"))
      );
    }
  }

  Future<void> _showAddCommentBox() async {
    _commentController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: MyTextField(
          controller: _commentController,
          hintText: "Write your comment...",
          obscureText: false,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () async {
              if (_commentController.text.isNotEmpty) {
                setState(() {
                  _isLoading = true;
                });

                Navigator.pop(context);

                final username = _authCubit.currentUser?.email ?? "user";

                await _postCubit.addComment(
                  postId: widget.post.id,
                  text: _commentController.text,
                  username: username
                );

                await _loadComments();
              }
            },
            child: const Text("Post")
          )
        ],
      ),
    );
  }

  Future<void> _showDeleteCommentBox(String commentId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Comment"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });

              await _postCubit.deleteComment(
                commentId: commentId,
                postId: widget.post.id
              );

              await _loadComments();

            },
            child: const Text("Delete")
          )
        ],
      ),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        actions: [
          IconButton(
            onPressed: _showAddCommentBox, 
            icon: const Icon(Icons.add_comment)
          )
        ]
        ),

        body: RefreshIndicator(
          onRefresh: _loadComments,
          child: ListView(
            children: [
              PostTile(
                post: widget.post,
                commentCount: _comments.length,
                onDelete: () {},
                onTap: () {},
              ),
              Divider(indent: 16, endIndent: 16, color: Theme.of(context).colorScheme.tertiary),
            
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_comments.isEmpty)
                const Text("No comment yet...")

              else 
                ListView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];

                    return CommentTile(
                      comment: comment,
                      onDelete: () => _showDeleteCommentBox(comment.id),
                    );
                  }
                )

              
            ]
          )
        )
    );
  }
}