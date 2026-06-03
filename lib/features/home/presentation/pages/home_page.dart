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


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length:3, vsync: this);
  
  late final postCubit = context.read<PostCubit>();
  
  @override
  void initState() {
    super.initState();

    postCubit.loadPosts();
  }

  void addPost() {
    String currentCategory;
    switch (_tabController.index) {
      case 0:
        currentCategory = "Create";
        break;
      case 1:
        currentCategory = "Publish";
        break;
      case 2:
        currentCategory = "Earn";
        break;
      default:
        currentCategory = "Create";
    }
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Post"),
        content: Column(
          children: [
            MyTextField(
              controller: titleController,
              hintText: "Title",
              obscureText: false),
              const SizedBox(height: 16),

            MyTextField(
              controller: contentController, 
              hintText: "Content",
              obscureText: false, 
            )
          ]
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () {
            if (titleController.text.isNotEmpty) {
              final postCubit = context.read<PostCubit>();
              final authCubit = context.read<AuthCubit>();
              postCubit.createPost(
                title: titleController.text,
                content: contentController.text,
                category: currentCategory,
                username: authCubit.currentUser!.email // Replace with actual username
              );

              Navigator.pop(context); 
              
            }
          }, child: const Text("Post"))
        ]
      )
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
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () {
              postCubit.deletePost(id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          )
        ]

      )
    );

  }

  Widget _buildCategoryPosts(String category, List<Post> posts) {
    final postsInThisCategory = posts.where((post) => post.category == category).toList();

    if (postsInThisCategory.isEmpty) {
      return const Center(child: Text("No posts here yet!"));
    }

    return ListView.separated(
      itemCount: postsInThisCategory.length,
      separatorBuilder: (context, index) => Divider(
        indent: 16, endIndent: 16,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      itemBuilder: (context, index) {
        final post = postsInThisCategory[index];

        return PostTile(post: post, onDelete: () => deletePost(post.id),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(post: post),),);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:Text("Home"),

            bottom: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: "Create"),
                Tab(text:"Publish"),
                Tab(text:"Earn")
              ]
            ),
            actions: [
              IconButton(onPressed: addPost ,
              icon: const Icon(Icons.add),
              )
            ]

        ),
        drawer: MyDrawer(),

        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state is PostsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryPosts("Create", state.posts),
                _buildCategoryPosts("Publish", state.posts),
                _buildCategoryPosts("Earn", state.posts)
              ],
            );


          }
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();

        },),);
  }
}