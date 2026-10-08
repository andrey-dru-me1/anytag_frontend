// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createApiClient() {
  const configuredBaseUrl = String.fromEnvironment('BASE_URL');

  final baseUrl = configuredBaseUrl.isNotEmpty
      ? configuredBaseUrl
      : defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:3000/api/v1'
      : 'http://127.0.0.1:3000/api/v1';

  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
