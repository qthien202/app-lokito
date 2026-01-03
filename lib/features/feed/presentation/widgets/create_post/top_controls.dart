import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lokito/features/feed/presentation/controllers/create_post_state.dart';

class TopControls extends StatelessWidget {
  final CreatePostStep currentStep;
  final bool hasImage;
  final VoidCallback onBack;
  final VoidCallback? onSend;
  final VoidCallback? onGallery;

  const TopControls({
    super.key,
    required this.currentStep,
    required this.hasImage,
    required this.onBack,
    this.onSend,
    this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            onTap: onBack,
            icon: hasImage ? LucideIcons.arrowLeft : LucideIcons.x,
          ),
          if (!hasImage)
            _buildActionButton(onTap: onGallery, icon: LucideIcons.image)
          else
            GestureDetector(
              onTap: onSend,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.feed.createPost.send,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      LucideIcons.sendHorizontal,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
