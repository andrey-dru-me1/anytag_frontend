// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anytag_frontend/models/post.dart';
import 'package:anytag_frontend/screens/posts_screen.dart';

import '../fakes/post_service_fake.dart';

Widget _buildApp(FakePostService postService) {
  return MaterialApp(home: PostsScreen(postService: postService));
}

/// Drain pending timers created during widget tree disposal.
///
/// The [PostCard] widget uses `markdown_widget` whose transitive dependency
/// `visibility_detector` stores a non-periodic 500 ms timer in a paint
/// composition callback. When the widget tree is disposed (during test
/// teardown), the layer `detach` fires those composition callbacks, which
/// schedule a new timer. This helper replaces the widget tree with an empty
/// [Container], allowing the timer to fire harmlessly.
///
/// This is a `flutter_test` platform limitation — it exists regardless of the
/// service implementation (Fake or real).
Future<void> _drainTimers(WidgetTester tester) async {
  await tester.pumpWidget(Container());
  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  group('PostsScreen', () {
    testWidgets('shows a loading indicator initially', (tester) async {
      // Never-completing future — keeps the widget in loading state.
      final service = FakePostService(future: Completer<List<Post>>().future);

      await tester.pumpWidget(_buildApp(service));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows posts when fetch succeeds', (tester) async {
      final posts = [
        const Post(id: 1, text: 'First post'),
        const Post(id: 2, text: 'Second post'),
      ];

      final service = FakePostService(posts: posts);
      await tester.pumpWidget(_buildApp(service));

      await tester.pumpAndSettle();

      try {
        expect(find.text('First post'), findsOneWidget);
        expect(find.text('Second post'), findsOneWidget);
      } finally {
        // Drain visibility_detector timers even when assertions fail.
        await _drainTimers(tester);
      }
    });

    testWidgets('shows error text when fetch fails', (tester) async {
      final service = FakePostService(error: Exception('server error'));
      await tester.pumpWidget(_buildApp(service));

      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('shows empty state when there are no posts', (tester) async {
      final service = FakePostService();
      await tester.pumpWidget(_buildApp(service));

      await tester.pumpAndSettle();

      expect(find.text('No posts available.'), findsOneWidget);
    });
  });
}
