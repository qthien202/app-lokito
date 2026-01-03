import 'dart:io';
import 'package:flutter/material.dart';

class PreviewView extends StatelessWidget {
  final File? capturedImage;
  final VoidCallback onRetake;

  const PreviewView({
    super.key,
    required this.capturedImage,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    if (capturedImage == null) return const SizedBox();

    return Image.file(
      capturedImage!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
