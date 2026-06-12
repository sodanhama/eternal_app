import 'package:eternal_app/components/drawer.dart';
import 'package:eternal_app/features/auth/presentation/components/my_textfield.dart';
import 'package:eternal_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:eternal_app/features/home/domain/entities/post.dart';
import 'package:eternal_app/features/home/presentation/components/post_tile.dart';
import 'package:eternal_app/features/home/presentation/cubits/post_cubit.dart';
import 'package:eternal_app/features/home/presentation/cubits/post_states.dart';
import 'package:eternal_app/features/home/presentation/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();
 
  @override
  void initState() {
    super.initState();
    postCubit.loadPosts();
  }
 
  void addPost() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Post"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              controller: titleController,
              hintText: "Title",
              obscureText: false,
            ),
            const SizedBox(height: 16),
            MyTextField(
              controller: contentController,
              hintText: "Content",
              obscureText: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final authCubit = context.read<AuthCubit>();
                postCubit.createPost(
                  title: titleController.text,
                  content: contentController.text,
                  category: "General",
                  username: authCubit.currentUser!.email,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }
 
  void deletePost(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              postCubit.deletePost(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: addPost,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostsLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text("No posts yet!"));
            }
 
            return ListView.separated(
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => Divider(
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                final commentCount = state.commentCounts[post.id] ?? 0;
 
                return PostTile(
                  post: post,
                  onDelete: () => deletePost(post.id),
                  commentCount: commentCount,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostPage(post: post),
                      ),
                    );
                  },
                );
              },
            );
          }
 
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
 
          if (state is PostError) {
            return Center(child: Text(state.message));
          }
 
          return const SizedBox();
        },
      ),
    );
  }
}