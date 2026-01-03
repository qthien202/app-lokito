import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CaptionView extends StatelessWidget {
  final File? capturedImage;
  final TextEditingController captionController;
  final bool isLoading;
  final VoidCallback onShare;

  const CaptionView({
    super.key,
    required this.capturedImage,
    required this.captionController,
    required this.isLoading,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Image preview (small)
            _buildImagePreview(theme),
            
            // Caption input section
            Expanded(
              child: _buildCaptionSection(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: capturedImage != null
            ? Image.file(
                capturedImage!,
                fit: BoxFit.cover,
              )
            : Container(
                color: theme.colorScheme.surfaceVariant,
                child: const Icon(LucideIcons.image),
              ),
      ),
    );
  }

  Widget _buildCaptionSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.feed.createPost.addCaption,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Caption text field
          Expanded(
            child: TextField(
              controller: captionController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: t.feed.createPost.addCaption,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Share button
          _buildShareButton(theme),
        ],
      ),
    );
  }

  Widget _buildShareButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onShare,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                t.feed.createPost.share,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}