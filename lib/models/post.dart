// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

class Post {
  final int id;
  final String text;

  Post({
    required this.id,
    required this.text,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}
