import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

MarkdownStyleSheet getGitHubMarkdownStyle(BuildContext context) {
  return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
    // 1. Заголовки (крупные, полужирные, с нижним разделителем для h1 и h2)
    h1: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2328),
    ),
    h2: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2328),
    ),
    h3: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1F2328),
    ),

    // 2. Обычный текст
    p: const TextStyle(fontSize: 16, color: Color(0xFF1F2328), height: 1.5),

    // 3. Инлайновый код (как в `код` на GitHub — серый фон, моноширинный шрифт)
    code: const TextStyle(
      fontFamily: 'Courier', // Или любой моноширинный шрифт вашего проекта
      fontSize: 14,
      color: Color(0xFF1F2328),
      backgroundColor: Color(0xFFEFF1F3), // Светло-серый фон
    ),

    // 4. Цитаты (Blockquote — серая вертикальная линия слева)
    blockquote: const TextStyle(
      fontSize: 16,
      color: Color(0xFF65717D),
      fontStyle: FontStyle.normal,
    ),
    blockquotePadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
    blockquoteDecoration: const BoxDecoration(
      border: Border(
        left: BorderSide(color: Color(0xFFD0D7DE), width: 4), // Та самая линия
      ),
    ),

    // 5. Блоки кода (Pre)
    codeblockPadding: const EdgeInsets.all(16),
    codeblockDecoration: BoxDecoration(
      color: const Color(0xFFF6F8FA), // Фирменный фон блоков кода GitHub
      borderRadius: BorderRadius.circular(6),
    ),

    // 6. Таблицы
    tableBorder: TableBorder.all(color: const Color(0xFFD0D7DE), width: 1),
    tableCellsPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),

    // Отступы между абзацами
    blockSpacing: 16,
  );
}
