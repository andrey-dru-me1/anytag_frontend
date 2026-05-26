import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:markdown_widget/markdown_widget.dart';

import 'package:anytag_frontend/widgets/intrinsic_shield.dart';

SpanNodeGeneratorWithTag latexGenerator = SpanNodeGeneratorWithTag(
  tag: _latexTag,
  generator: (e, config, visitor) =>
      LatexNode(e.attributes, e.textContent, config),
);

const _latexTag = 'latex';

class LatexInlineSyntax extends m.InlineSyntax {
  LatexInlineSyntax() : super(r'\$([^$\n]+?)\$');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    final content = match.group(1) ?? '';
    m.Element el = m.Element.text(_latexTag, content);
    el.attributes['isInline'] = 'true';
    parser.addNode(el);
    return true;
  }
}

class LatexBlockSyntax extends m.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^\s*\$\$\s*$');

  const LatexBlockSyntax();

  @override
  m.Node parse(m.BlockParser parser) {
    final childLines = <String>[];

    // Skip opening $$
    parser.advance();

    // Read while $$ are met
    while (!parser.isDone) {
      final line = parser.current.content;
      final match = pattern.firstMatch(line);
      if (match != null) {
        parser.advance();
        break;
      }
      childLines.add(line);
      parser.advance();
    }

    final content = childLines.join('\n');
    return m.Element.text(_latexTag, content);
  }
}

class LatexNode extends SpanNode {
  final Map<String, String> attributes;
  final String textContent;
  final MarkdownConfig config;

  LatexNode(this.attributes, this.textContent, this.config);

  @override
  InlineSpan build() {
    final isInline = attributes['isInline'] == 'true';

    // parentStyle from ConcreteElementNode defaults to const TextStyle()
    // (null fontSize/color), which causes null check errors in
    // flutter_math_fork's Math.build() (fontSize! and color!).
    final parent = parentStyle;
    final fontSize = parent?.fontSize ?? 16;
    final style = (parent ?? const TextStyle()).copyWith(
      fontSize: fontSize,
      color: parent?.color ?? Colors.black,
    );

    final latex = Math.tex(
      textContent,
      mathStyle: MathStyle.text,
      textStyle: style,
      textScaleFactor: 1,
      onErrorFallback: (error) {
        return Text(textContent, style: style.copyWith(color: Colors.red));
      },
    );

    if (!isInline) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: latex),
        ),
      );
    }

    // Wrap inline math in IntrinsicShield to prevent the intrinsic size
    // measurement cascade from RenderTable -> RenderParagraph -> WidgetSpan
    // -> flutter_math_fork's render tree (which contains LayoutBuilder and
    // triggers a debug assertion during intrinsic measurement).
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: IntrinsicShield(
        fontSize: fontSize,
        child: latex,
      ),
    );
  }
}
