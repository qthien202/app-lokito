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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        textAlign: TextAlign.start,
        minLines: 1,
        maxLines: 4,
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (_) => onSend(),
        decoration: InputDecoration(
          hintText: t.feed.createPost.addCaption,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.edit_outlined,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }
}
