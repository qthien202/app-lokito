import 'package:flutter/material.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AudienceSelector extends StatelessWidget {
  const AudienceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pillColor = isDark
        ? Colors.white.withOpacity(0.08)
        : theme.colorScheme.surfaceVariant.withOpacity(0.5);
    final textColor = theme.colorScheme.onSurface;

    return Row(
      children: [
        // Modern Avatar Stack
        SizedBox(
          width: 96,
          height: 40,
          child: Stack(
            children: [
              _buildAvatar('https://i.pravatar.cc/100?img=1', 0, theme),
              _buildAvatar('https://i.pravatar.cc/100?img=2', 20, theme),
              _buildAvatar('https://i.pravatar.cc/100?img=3', 40, theme),
              Positioned(
                left: 60,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: pillColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '+5',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        // Refined Selector Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF00BA7C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Color(0xFF00BA7C), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                t.feed.createPost.toBestFriends,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                LucideIcons.chevronDown,
                size: 16,
                color: textColor.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String url, double left, ThemeData theme) {
    return Positioned(
      left: left,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.surface, width: 2),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
