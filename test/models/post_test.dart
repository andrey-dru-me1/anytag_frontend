// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter_test/flutter_test.dart';

import 'package:anytag_frontend/models/post.dart';

void main() {
  group('Post.fromJson', () {
    test('parses a valid JSON map correctly', () {
      final json = <String, dynamic>{'id': 1, 'text': 'Hello, world!'};
      final post = Post.fromJson(json);

      expect(post.id, equals(1));
      expect(post.text, equals('Hello, world!'));
    });

    test('parses a JSON map with an empty text', () {
      final json = <String, dynamic>{'id': 42, 'text': ''};
      final post = Post.fromJson(json);

      expect(post.id, equals(42));
      expect(post.text, isEmpty);
    });

    test('throws TypeError when id is not an int', () {
      final json = <String, dynamic>{'id': 'not-an-int', 'text': 'oops'};

      expect(() => Post.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('throws TypeError when text is not a String', () {
      final json = <String, dynamic>{'id': 1, 'text': 123};

      expect(() => Post.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('Post equality', () {
    test('two identical posts are equal', () {
      final a = Post(id: 1, text: 'foo');
      final b = Post(id: 1, text: 'foo');

      expect(a, equals(b));
    });

    test('equal posts have equal hash codes', () {
      final a = Post(id: 1, text: 'foo');
      final b = Post(id: 1, text: 'foo');

      expect(a.hashCode, equals(b.hashCode));
    });

    test('posts with different ids are not equal', () {
      final a = Post(id: 1, text: 'foo');
      final b = Post(id: 2, text: 'foo');

      expect(a, isNot(equals(b)));
    });

    test('posts with different texts are not equal', () {
      final a = Post(id: 1, text: 'foo');
      final b = Post(id: 1, text: 'bar');

      expect(a, isNot(equals(b)));
    });
  });
}
