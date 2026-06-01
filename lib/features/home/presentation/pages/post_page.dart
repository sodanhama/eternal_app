import 'package:eternal_app/features/home/domain/entities/post.dart';
import 'package:eternal_app/features/home/presentation/components/post_tile.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        ),
        body: Column(
          children: [
            PostTile(
              post: post, 
              onDelete: () {}, 
              onTap: () {},),
          ],

        )
    );
  }
}