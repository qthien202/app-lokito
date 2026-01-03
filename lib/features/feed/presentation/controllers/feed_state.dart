import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/post_model.dart';

part 'feed_state.freezed.dart';

@freezed
abstract class FeedState with _$FeedState {
  const factory FeedState({
    @Default([]) List<PostModel> posts,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(0) int currentPage,
    String? error,
    @Default(false) bool isRefreshing,
    @Default(true) bool isInitializing, // New field for initial load
  }) = _FeedState;
}
