import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lokito/core/core.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../domain/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;

  const PostCard({super.key, required this.post, this.onLike, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = MediaQuery.platformBrightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surface,
      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: CachedNetworkImageProvider(
                        AvatarUtils.getAvatarUrl(
                          avatarUrl: post.authorAvatar,
                          name: post.authorName,
                          size: 72, // 18 * 2 * 2 for high DPI
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.authorName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          timeago.format(
                            post.createdAt,
                            locale: LocaleSettings.currentLocale.languageCode,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: Icon(LucideIcons.ellipsis),
                  onSelected: (value) {
                    if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(LucideIcons.trash2, size: 16),
                          SizedBox(width: 8),
                          Text(t.feed.delete),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (post.content.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                post.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                if (post.isUploading) return;
                showFullscreenImage(
                  context,
                  imageUrl: post.fullImageUrl,
                  postId: post.id,
                  heroTag: 'post_image_${post.id}',
                  title: post.authorName,
                );
              },
              child: Hero(
                tag: 'post_image_${post.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      // Layer 1: Local image backdrop (Prevents flickering)
                      if (post.localImagePath != null)
                        Image.file(
                          File(post.localImagePath!),
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),

                      // Layer 2: Network image (Loads over local image)
                      if (post.imageUrl.startsWith('http'))
                        CachedNetworkImage(
                          imageUrl: post.imageUrl,
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              post.localImagePath != null
                              ? const SizedBox.shrink()
                              : Shimmer.fromColors(
                                  baseColor: theme.colorScheme.surfaceVariant,
                                  highlightColor: theme
                                      .colorScheme
                                      .surfaceVariant
                                      .withOpacity(0.5),
                                  child: Container(
                                    height: 300,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                ),
                          errorWidget: (context, url, error) => Container(
                            height: 300,
                            color: theme.colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                LucideIcons.imageOff,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),

                      // Layer 3: Modern Uploading Effect (Blur + Dim)
                      if (post.isUploading)
                        Positioned.fill(
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10 * (1 - post.uploadProgress),
                                sigmaY: 10 * (1 - post.uploadProgress),
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(
                                  (0.6 * (1 - post.uploadProgress)).clamp(
                                    0.0,
                                    1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.cornerUpLeft,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              t.feed.reply,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onLike,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          post.isLiked ? Iconsax.heart : Iconsax.heart,
                          color: post.isLiked
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        // Only show count if there's at least one like from someone else
                        if ((post.likes - (post.isLiked ? 1 : 0)) > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            post.likes.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
