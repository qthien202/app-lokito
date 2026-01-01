import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[300],
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const SkeletonAvatar({
    super.key,
    this.size = 36,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      margin: margin,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

class SkeletonButton extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonButton({
    super.key,
    this.width,
    this.height = 40,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(12),
    );
  }
}

// Shimmer wrapper for existing widgets
class SkeletonShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const SkeletonShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}