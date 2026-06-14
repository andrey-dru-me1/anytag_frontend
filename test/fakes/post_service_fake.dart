// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'dart:async';

import 'package:anytag_frontend/models/post.dart';
import 'package:anytag_frontend/services/post_service.dart';

/// A fake [IPostService] that returns predefined posts or throws an error.
/// Completely avoids creating a [Dio] instance (no pending timers).
class FakePostService implements IPostService {
  FakePostService({this.posts = const [], this.error, this.future});

  final List<Post> posts;
  final Object? error;

  /// When provided, [fetchPosts] returns this future instead of the default
  /// behaviour. Used to simulate a never-completing request for the loading
  /// indicator test.
  final Future<List<Post>>? future;

  @override
  Future<List<Post>> fetchPosts() async {
    if (future != null) return future!;
    if (error != null) throw error!;
    return posts;
  }
}
