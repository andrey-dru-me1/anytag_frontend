// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';

import '../models/post.dart';
import 'api_client.dart';

/// Abstract interface for fetching posts.
///
/// Allows production code ([PostService]) and test code ([FakePostService])
/// to share a common contract without the service knowing about tests.
abstract class IPostService {
  Future<List<Post>> fetchPosts();
}

class PostService implements IPostService {
  final Dio _dio;

  PostService({Dio? dio}) : _dio = dio ?? createApiClient();

  @override
  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get('/posts');
    try {
      final Map<String, dynamic> body = response.data as Map<String, dynamic>;
      final List<dynamic> data = body['posts'] as List<dynamic>;
      return data
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    } on TypeError catch (e) {
      throw FormatException('Invalid posts response format', e);
    }
  }
}
