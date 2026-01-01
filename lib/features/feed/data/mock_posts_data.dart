import '../domain/post_model.dart';

class MockPostsData {
  static bool _showEmptyState = false;
  static bool _forceLoading = false;
  
  // Toggle empty state for testing
  static void toggleEmptyState() {
    _showEmptyState = !_showEmptyState;
  }
  
  static bool get isEmptyState => _showEmptyState;

  // Force loading state for testing skeleton
  static void toggleForceLoading() {
    _forceLoading = !_forceLoading;
  }
  
  static bool get isForceLoading => _forceLoading;

  static List<PostModel> get posts {
    if (_showEmptyState) return [];
    
    return [
      PostModel(
        id: '1',
        authorName: 'Nguyễn Văn A',
        authorAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop',
        content: 'Một ngày tuyệt vời tại bãi biển! 🌊☀️ #beach #summer #vacation',
        isLiked: false,
        likes: 24,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
      ),
      PostModel(
        id: '2',
        authorName: 'Trần Thị B',
        authorAvatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&h=400&fit=crop',
        content: 'Bữa tối ngon miệng với gia đình 🍽️❤️ #family #dinner #homemade',
        isLiked: true,
        likes: 45,
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
      ),
      PostModel(
        id: '3',
        authorName: 'Lê Văn C',
        authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop',
        content: 'Văn phòng mới, năng lượng mới! 💼✨ #office #work #newbeginnings',
        isLiked: false,
        likes: 12,
        createdAt: DateTime.now().subtract(Duration(hours: 8)),
      ),
      PostModel(
        id: '4',
        authorName: 'Phạm Thị D',
        authorAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop',
        content: 'Thiên nhiên thật tuyệt vời! 🌲🏔️ #nature #hiking #mountains',
        isLiked: true,
        likes: 67,
        createdAt: DateTime.now().subtract(Duration(hours: 12)),
      ),
      PostModel(
        id: '5',
        authorName: 'Hoàng Văn E',
        authorAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop',
        content: 'Coding session với cà phê ☕💻 #coding #coffee #developer',
        isLiked: false,
        likes: 89,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      PostModel(
        id: '6',
        authorName: 'Vũ Thị F',
        authorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?w=400&h=400&fit=crop',
        content: 'Bữa sáng healthy để bắt đầu ngày mới! 🥗🍓 #healthy #breakfast #lifestyle',
        isLiked: true,
        likes: 34,
        createdAt: DateTime.now().subtract(Duration(days: 1, hours: 3)),
      ),
      PostModel(
        id: '7',
        authorName: 'Đỗ Văn G',
        authorAvatar: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400&h=400&fit=crop',
        content: 'Buổi tối thư giãn với âm nhạc 🎵🌙 #music #relax #evening',
        isLiked: false,
        likes: 56,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
      PostModel(
        id: '8',
        authorName: 'Bùi Thị H',
        authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400&h=400&fit=crop',
        content: 'Workout buổi sáng để có năng lượng cả ngày! 💪🏃‍♀️ #fitness #workout #morning',
        isLiked: true,
        likes: 78,
        createdAt: DateTime.now().subtract(Duration(days: 2, hours: 6)),
      ),
      PostModel(
        id: '9',
        authorName: 'Ngô Văn I',
        authorAvatar: 'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop',
        content: 'Chuyến du lịch khám phá thành phố mới 🏙️✈️ #travel #city #explore',
        isLiked: false,
        likes: 92,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      PostModel(
        id: '10',
        authorName: 'Lý Thị K',
        authorAvatar: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?w=400&h=400&fit=crop',
        content: 'Học hỏi những điều mới mỗi ngày 📚💡 #learning #books #knowledge',
        isLiked: true,
        likes: 41,
        createdAt: DateTime.now().subtract(Duration(days: 3, hours: 8)),
      ),
    ];
  }

  // Simulate more posts for pagination
  static List<PostModel> getMorePosts(int page) {
    if (_showEmptyState) return [];
    
    final baseId = page * 10;
    return List.generate(10, (index) {
      final id = baseId + index + 1;
      return PostModel(
        id: id.toString(),
        authorName: 'User $id',
        authorAvatar: 'https://images.unsplash.com/photo-${1472099645785 + id}?w=150&h=150&fit=crop&crop=face',
        imageUrl: 'https://images.unsplash.com/photo-${1506905925346 + id}?w=400&h=400&fit=crop',
        content: 'This is post number $id with some interesting content! #post$id',
        isLiked: id % 3 == 0,
        likes: (id * 7) % 100,
        createdAt: DateTime.now().subtract(Duration(days: page + 1, hours: index)),
      );
    });
  }
}