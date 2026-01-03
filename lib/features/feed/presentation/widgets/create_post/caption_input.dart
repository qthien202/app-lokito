import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';

class CaptionInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const CaptionInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      onSubmitted: (_) => onSend(),
      decoration: InputDecoration(
        hintText: t.feed.createPost.addCaption,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        // Ensure ALL borders are none to avoid "double input" look
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
    );
  }
}
