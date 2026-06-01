import 'package:eternal_app/features/home/domain/entities/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final void Function()? onDelete;
  final void Function()? onTap;
  final int commentCount;

  const PostTile({
    super.key, 
    required this.post, 
    required this.onDelete, 
    required this.onTap, 
    this.commentCount=0,
    });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                        
          Text(
            post.title, 
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 18
              )
              ),
        
              
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.cancel, color: Theme.of(context).colorScheme.primary)
              )
            ],
          ),
              
          const SizedBox(height: 10),
        
              
          Text(
            post.content, 
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary, 
              fontSize: 16
              )
              ),
        
          
          const SizedBox(height: 5),
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                post.username,
                style: TextStyle(
                color: Theme.of(context).colorScheme.primary, 
                fontSize: 12, 
                )
                  ),
        
              Text(
                commentCount.toString() + " comments",
                style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12, 
                )
              )
            ],
          ),
        ]),
      ),
    );
  }
}