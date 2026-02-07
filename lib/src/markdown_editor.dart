import 'package:flutter/material.dart';
import 'markdown_text_editing_controller.dart';

class MarkdownEditor extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final InputDecoration? decoration;

  const MarkdownEditor({
    super.key,
    this.initialValue,
    this.onChanged,
    this.style,
    this.decoration,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  late final MarkdownEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MarkdownEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      style: widget.style,
      decoration: widget.decoration,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }
}
