// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anytag_frontend/main.dart';
import 'package:anytag_frontend/screens/posts_screen.dart';

import 'fakes/post_service_fake.dart';

void main() {
  testWidgets('MyApp renders PostsScreen', (WidgetTester tester) async {
    final service = FakePostService();

    await tester.pumpWidget(MyApp(postService: service));

    // The app bar title should be "Posts" as defined in PostsScreen.
    expect(find.text('Posts'), findsOneWidget);

    // The MyApp should be a MaterialApp wrapping PostsScreen.
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(PostsScreen), findsOneWidget);
  });
}
