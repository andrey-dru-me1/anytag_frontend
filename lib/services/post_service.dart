// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

/// Abstract interface for fetching posts.
///
/// Allows production code ([PostService]) and test code ([FakePostService])
/// to share a common contract without the service knowing about tests.
abstract class IPostService {
  Future<List<Post>> fetchPosts();
}

class PostService implements IPostService {
  final Dio _dio;

  PostService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              // Use 10.0.2.2 for Android emulator (maps to host localhost),
              // 127.0.0.1 for iOS simulator and other platforms.
              baseUrl: _defaultBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  static String get _defaultBaseUrl {
    const configuredBaseUrl = String.fromEnvironment('BASE_URL');

    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api/v1';
    }

    return 'http://127.0.0.1:3000/api/v1';
  }

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
