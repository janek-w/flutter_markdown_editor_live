# Markdown Editor Live for Flutter

A Flutter widget that provides a **WYSIWYG-style markdown editing experience** with live syntax highlighting (similar to Obsidian or Typora). Markdown syntax is displayed only on the line you're currently editing, and on other lines, the formatted result is shown directly.

[![pub package](https://img.shields.io/pub/v/markdown_editor_live.svg)](https://pub.dev/packages/markdown_editor_live)
[![License: BSD-3](https://img.shields.io/badge/license-BSD--3-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

## Features

- **Live WYSIWYG Editing** — Syntax markers (like `**`, `#`, etc.) are hidden except on the line you're currently editing
- **Syntax Highlighting** — Visual distinction for headers, bold, italic, code, and more
- **Auto-Continuing Lists** — Press Enter on a list item to automatically add the next bullet or number
- **Tab Support** — Tab key inserts indentation; supports both soft tabs (spaces) and hard tabs
- **Multi-line Selection Indent** — Select multiple lines and press Tab to indent them all
- **Customizable Styling** — Pass your own `TextStyle` and `InputDecoration`

### Currently Supported Markdown Syntax

| Element           | Syntax                        |
|-------------------|-------------------------------|
| Headers (H1–H6)   | `# Header` through `###### H6`|
| Bold              | `**text**` or `__text__`      |
| Italic            | `*text*` or `_text_`          |
| Strikethrough     | `~~text~~`                    |
| Inline code       | `` `code` ``                  |
| Code blocks       | ` ``` code ``` `              |
| Unordered lists   | `- item`, `* item`, `+ item`  |
| Ordered lists     | `1. item`, `2. item`          |
| Thematic breaks   | `---`, `***`, `___`           |

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  markdown_editor_live: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:markdown_editor_live/markdown_editor_live.dart';

class MyEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MarkdownEditor(
      initialValue: '# Hello World\n\nThis is **bold** and *italic*.',
      onChanged: (text) {
        print('Content: $text');
      },
    );
  }
}
```

### With Custom Styling

```dart
MarkdownEditor(
  initialValue: '# Styled Editor',
  onChanged: (text) => setState(() => _content = text),
  style: const TextStyle(
    fontSize: 16,
    fontFamily: 'Roboto',
    height: 1.5,
  ),
  decoration: const InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Start typing markdown...',
  ),
)
```

### Tab Configuration

Control how the Tab key behaves:

```dart
MarkdownEditor(
  initialValue: 'Press Tab to indent!',
  useSoftTabs: true,   // Use spaces instead of \t (default: true)
  tabWidth: 4,         // Number of spaces per tab (default: 2)
)
```

## API Reference

### MarkdownEditor

| Property       | Type                  | Default | Description                              |
|----------------|-----------------------|---------|------------------------------------------|
| `initialValue` | `String?`             | `null`  | Initial markdown content                 |
| `onChanged`    | `ValueChanged<String>?` | `null`| Callback when content changes            |
| `style`        | `TextStyle?`          | `null`  | Text style for the editor                |
| `decoration`   | `InputDecoration?`    | `null`  | Input decoration for the TextField       |
| `useSoftTabs`  | `bool`                | `true`  | Use spaces instead of tab characters     |
| `tabWidth`     | `int`                 | `2`     | Number of spaces per soft tab            |

### MarkdownEditingController

For advanced use cases, you can use `MarkdownEditingController` directly with a standard `TextField`:

```dart
final controller = MarkdownEditingController(text: '# My Content');

TextField(
  controller: controller,
  maxLines: null,
)
```

## Example App

Check out the [example](example/) directory for a complete demo application showing the editor in action with a side-by-side raw text preview.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the BSD-3-Clause License — see the [LICENSE](LICENSE) file for details.


Created by [Janek](https://janekwenzlik.de)