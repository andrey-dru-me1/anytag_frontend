// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/post.dart';

class PostService {
  final Dio _dio;

  PostService()
      : _dio = Dio(BaseOptions(
          // Use 10.0.2.2 for Android emulator (maps to host localhost),
          // 127.0.0.1 for iOS simulator and other platforms.
          baseUrl: _defaultBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  static String get _defaultBaseUrl {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://127.0.0.1:3000';
  }

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get('/posts');
    final Map<String, dynamic> body = response.data as Map<String, dynamic>;
    final List<dynamic> data = body['posts'] as List<dynamic>;
    return data.map((json) => Post.fromJson(json as Map<String, dynamic>)).toList();
  }
}
