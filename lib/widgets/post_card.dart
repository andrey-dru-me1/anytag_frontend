// SPDX-FileCopyrightText: 2026 The Anytag Frontend Authors
// SPDX-License-Identifier: AGPL-3.0-only

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:anytag_frontend/models/post.dart';
import 'package:anytag_frontend/widgets/latex.dart';
import 'package:anytag_frontend/widgets/safe_table_scroll_wrapper.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.vertical,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
        // padding: EdgeInsets.symmetric(horizontal: 40),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(22),
        ),
        child: MarkdownWidget(
          data: post.text,
          shrinkWrap: true,
          selectable: false,
          config: MarkdownConfig(
            configs: [
              TableConfig(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                wrapper: (table) => SafeTableScrollWrapper(child: table),
              ),
              H1Config(
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          markdownGenerator: MarkdownGenerator(
            generators: [latexGenerator],
            inlineSyntaxList: [LatexInlineSyntax()],
            blockSyntaxList: [LatexBlockSyntax()],
          ),
        ),
      ),
    );
  }
}
