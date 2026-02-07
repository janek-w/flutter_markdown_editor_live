import 'package:flutter/material.dart';

class MarkdownEditingController extends TextEditingController {
  MarkdownEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    final String text = value.text;
    style ??= const TextStyle();

    // Reset styles
    children.add(TextSpan(text: text, style: style));

    // We will use a more robust approach:
    // 1. Iterate through the text and apply styles based on matches.
    // However, for simplicity and performance in this first step,
    // let's just highlight headers and bold.

    // A better approach for syntax highlighting is to parse the text into tokens
    // and build the TextSpan tree.

    return _parseMarkdown(text, style);
  }

  TextSpan _parseMarkdown(String text, TextStyle defaultStyle) {
    // This is a naive implementation that applies styles in a specific order.
    // Real markdown parsing is complex, but for this "WYSIWYG" effect where we keep
    // the source characters, we just need to highlight them.

    // We will use a list of style definitions.
    // Each definition has a regex and a style to apply.
    // We will iterate through the text and apply the styles.

    // To handle overlapping styles is complex.
    // FLUTTER EDITING CONTROLLER STRATEGY:
    // 1. Create a base list of children (just the full text).
    // 2. Iterate over our rules.
    // 3. For each rule, find all matches.
    // 4. For each match, split the existing spans to isolate the matching range, and apply the style.

    // Actually, a simpler way for this level of complexity is:
    // Scan the text for all matches of all types, sort them by start index,
    // and then build the spans. But nested styles (bold inside header) are tricky.

    // Let's stick to the simple strategy:
    // Process block elements (headers, code blocks) first (entire lines).
    // Process span elements (bold, italic) next.

    // However, `buildTextSpan` must return a single tree.

    // Let's use a simpler approach for this MVP:
    // We won't support nested styles efficiently yet. We will just find matches and style them.
    // If ranges overlap, the last one applied might win or we might have issues.
    // But for "Header" vs "Bold", typically Head is a line thing, Bold is inline.

    // Regex definitions
    final patterns = <_MarkdownPattern>[
      _MarkdownPattern(
        RegExp(r'^(#{1,6})\s+.*$', multiLine: true),
        (match) => const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.blueAccent,
        ),
      ), // Headers
      _MarkdownPattern(
        RegExp(r'\*\*(.*?)\*\*'),
        (match) => const TextStyle(fontWeight: FontWeight.bold),
      ), // Bold **
      _MarkdownPattern(
        RegExp(r'__(.*?)__'),
        (match) => const TextStyle(fontWeight: FontWeight.bold),
      ), // Bold __
      _MarkdownPattern(
        RegExp(r'\*(.*?)\*'),
        (match) => const TextStyle(fontStyle: FontStyle.italic),
      ), // Italic *
      _MarkdownPattern(
        RegExp(r'_(.*?)_'),
        (match) => const TextStyle(fontStyle: FontStyle.italic),
      ), // Italic _
      _MarkdownPattern(
        RegExp(r'~~(.*?)~~'),
        (match) => const TextStyle(decoration: TextDecoration.lineThrough),
      ), // Strikethrough
      _MarkdownPattern(
        RegExp(r'`(.*?)`'),
        (match) => TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey.shade200,
        ),
      ), // Inline Code
      _MarkdownPattern(
        RegExp(r'```([\s\S]*?)```'),
        (match) => TextStyle(
          fontFamily: 'monospace',
          backgroundColor: Colors.grey.shade200,
        ),
      ), // Block Code
    ];

    // We will use a character array to map each character to a style?
    // Too expensive?
    // Let's just create a list of styled ranges.

    final List<TextSpan> spans = [];

    // Sort of a "winner takes all" or "layering" approach?
    // Let's try to just find all matches and put them in a list.
    List<_MatchRange> ranges = [];

    for (final pattern in patterns) {
      for (final match in pattern.exp.allMatches(text)) {
        ranges.add(
          _MatchRange(match.start, match.end, pattern.styleBuilder(match)),
        );
      }
    }

    // Sort ranges by start position
    ranges.sort((a, b) => a.start.compareTo(b.start));

    // This is still naive because it doesn't handle nesting or overlaps well.
    // But it's a start.
    // Actually, if we have overlapping ranges, we should split them.
    // Writing a full robust styled text builder is a task on its own.

    // Allow me to use a simpler, non-nested approach just to get it working for the user's checklist.
    // We will iterate through the text and if we find a match that starts here, we use it.

    int cursor = 0;

    // To handle nesting properly, we really need a stack or a fine-grained generic parser.
    // Copilot/Gemini advice: Use a `splitMapJoin` approach or similar?
    // `splitMapJoin` is for one regex. We have multiple.

    // Let's use the 'ranges' to build the spans.
    // We need to merge overlapping ranges.
    // For now, let's just take the first range that covers a character.

    while (cursor < text.length) {
      // Find the range that starts at or before cursor, and ends after cursor.
      // If multiple, pick one (e.g. the one that started latest? or earliest?).
      // Let's pick the one that starts earliest, and if equal, looks longest.

      // Filter ranges relevant to current cursor
      final matches = ranges
          .where((r) => r.start <= cursor && r.end > cursor)
          .toList();

      if (matches.isEmpty) {
        // No style, find next start of a range or end of text
        int nextChange = text.length;
        for (var r in ranges) {
          if (r.start > cursor && r.start < nextChange) nextChange = r.start;
        }

        spans.add(
          TextSpan(
            text: text.substring(cursor, nextChange),
            style: defaultStyle,
          ),
        );
        cursor = nextChange;
      } else {
        // We are inside one or more styles.
        // Let's combine them? Or just pick one?
        // Let's pick the 'most specific' one? or just the first one found in our list priority.

        // Actually, our `ranges` list has all matches from all regexes.
        // Let's just pick the match that started earliest.
        // If we are effectively "inside" a match, let's continue until it ends, OR until another match starts?
        // Nested styling is hard: `**bold *italic* bold**`

        // Let's simplify: Just support non-overlapping matches for now.
        // We will take the first range in our sorted list, consume it, and skip others that overlap.

        final r = ranges.firstWhere(
          (r) => r.start >= cursor,
          orElse: () => _MatchRange(text.length, text.length, defaultStyle),
        );

        if (r.start > cursor) {
          spans.add(
            TextSpan(
              text: text.substring(cursor, r.start),
              style: defaultStyle,
            ),
          );
          cursor = r.start;
        }

        if (cursor < text.length && r.start == cursor && r.end > cursor) {
          spans.add(
            TextSpan(
              text: text.substring(r.start, r.end),
              style: defaultStyle.merge(r.style),
            ),
          );
          cursor = r.end;
          // Remove any ranges that we just stepped over/conflicted with
          // This effectively disables nesting but prevents crashes/infinite loops
          // ranges.removeWhere((other) => other.start < cursor);
          // But we are iterating...
        } else {
          // we reached end
          cursor = text.length;
        }
      }
    }

    return TextSpan(style: defaultStyle, children: spans);
  }
}

class _MarkdownPattern {
  final RegExp exp;
  final TextStyle Function(Match match) styleBuilder;
  _MarkdownPattern(this.exp, this.styleBuilder);
}

class _MatchRange {
  final int start;
  final int end;
  final TextStyle style;
  _MatchRange(this.start, this.end, this.style);
}
