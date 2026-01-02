import 'package:flutter/material.dart';
import 'post_card_skeleton.dart';

class PostListSkeleton extends StatelessWidget {
  final int itemCount;
  final bool useDebugVersion;

  const PostListSkeleton({
    super.key,
    this.itemCount = 5,
    this.useDebugVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return useDebugVersion 
            ? const PostCardSkeletonDebug()
            : const PostCardSkeleton();
      },
    );
  }
}

class PostListLoadingSkeleton extends StatelessWidget {
  final bool useDebugVersion;
  
  const PostListLoadingSkeleton({
    super.key,
    this.useDebugVersion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => useDebugVersion 
            ? const PostCardSkeletonDebug()
            : const PostCardSkeleton(),
      ),
    );
  }
}