// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:anytag_frontend/services/post_service.dart';
import 'package:anytag_frontend/models/post.dart';

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

class _FakeRequestOptions extends Fake implements RequestOptions {}

/// Creates a [Dio] with a mock adapter. Unit tests use `test()` (real async),
/// so timer assertions from `flutter_test`'s fake async zone do not apply.
Dio _mockDio() {
  final dio = Dio();
  dio.httpClientAdapter = _MockHttpClientAdapter();
  return dio;
}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequestOptions());
  });

  group('PostService.fetchPosts', () {
    test('returns a list of posts from valid JSON', () async {
      const json = '''
        {
          "posts": [
            {"id": 1, "text": "First post"},
            {"id": 2, "text": "Second post"}
          ]
        }
      ''';

      final dio = _mockDio();
      final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          json,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final service = PostService(dio: dio);
      final posts = await service.fetchPosts();

      expect(posts, hasLength(2));
      expect(posts[0], equals(const Post(id: 1, text: 'First post')));
      expect(posts[1], equals(const Post(id: 2, text: 'Second post')));
    });

    test('returns an empty list when the posts array is empty', () async {
      const json = '{"posts": []}';

      final dio = _mockDio();
      final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          json,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final service = PostService(dio: dio);
      final posts = await service.fetchPosts();

      expect(posts, isEmpty);
    });

    test('throws DioException on a 404 status code', () async {
      const json = '{"error": "not found"}';

      final dio = _mockDio();
      final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          json,
          404,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final service = PostService(dio: dio);

      await expectLater(
        () => service.fetchPosts(),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.badResponse,
          ),
        ),
      );
    });

    test(
      'throws FormatException when response body does not contain "posts" key',
      () async {
        const json = '{"data": []}';

        final dio = _mockDio();
        final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

        when(() => adapter.fetch(any(), any(), any())).thenAnswer(
          (_) async => ResponseBody.fromString(
            json,
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          ),
        );

        final service = PostService(dio: dio);

        expect(() => service.fetchPosts(), throwsA(isA<FormatException>()));
      },
    );

    test('throws FormatException when "posts" value is null', () async {
      const json = '{"posts": null}';

      final dio = _mockDio();
      final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          json,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final service = PostService(dio: dio);

      expect(() => service.fetchPosts(), throwsA(isA<FormatException>()));
    });

    test('throws FormatException when "posts" value is not a list', () async {
      const json = '{"posts": "not-a-list"}';

      final dio = _mockDio();
      final adapter = dio.httpClientAdapter as _MockHttpClientAdapter;

      when(() => adapter.fetch(any(), any(), any())).thenAnswer(
        (_) async => ResponseBody.fromString(
          json,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );

      final service = PostService(dio: dio);

      expect(() => service.fetchPosts(), throwsA(isA<FormatException>()));
    });
  });
}
