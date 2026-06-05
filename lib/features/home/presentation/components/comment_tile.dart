import 'package:eternal_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:eternal_app/features/home/domain/entities/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentTile extends StatelessWidget {
  final Comment comment; 
  final void Function() onDelete;

  const CommentTile({super.key, required this.comment, required this.onDelete});

  @override
  Widget build(BuildContext context) {

    final authCubit = context.read<AuthCubit>();
    final String currentUsername = authCubit.currentUser?.email ?? '';

    final bool canDelete = (comment.username == currentUsername); 

    return Container(
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
            Text(comment.text),
                    if (canDelete)
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete),
          ),
            Text(comment.username),


          ],),
        



      );
  }
}