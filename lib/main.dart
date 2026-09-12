// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';

import 'package:anytag_frontend/screens/posts_screen.dart';
import 'package:anytag_frontend/services/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.postService});

  /// Optional [IPostService] override for testing or dependency injection.
  final IPostService? postService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anytag',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: PostsScreen(postService: postService),
    );
  }
}
