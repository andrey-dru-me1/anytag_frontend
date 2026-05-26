// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:anytag_frontend/widgets/latex.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'models/post.dart';
import 'services/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anytag',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PostsScreen(),
    );
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _postService = PostService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postService.fetchPosts();
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _postService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return UnconstrainedBox(
                constrainedAxis: Axis.vertical,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 550),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: MarkdownWidget(
                    data: post.text,
                    shrinkWrap: true,
                    selectable: false,
                    markdownGenerator: MarkdownGenerator(
                      generators: [latexGenerator],
                      inlineSyntaxList: [LatexInlineSyntax()],
                      blockSyntaxList: [LatexBlockSyntax()],
                    ),
                  ),
                  // child: MarkdownBody(
                  //   data: post.text,
                  //   styleSheet: getGitHubMarkdownStyle(context),
                  //   builders: {'latex': LatexInlineElementBuilder()},
                  //   extensionSet: md.ExtensionSet(
                  //     [
                  //       LatexBlockSyntax(),
                  //       ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  //     ],
                  //     [
                  //       LatexInlineSyntax(),
                  //       ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
                  //     ],
                  //   ),
                  // ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshPosts,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
