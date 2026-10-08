// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  AuthService({Dio? dio}) : _dio = dio ?? createApiClient();

  final Dio _dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final body = response.data;
    if (body == null) {
      throw const FormatException('Empty login response');
    }
    return body;
  }
}
