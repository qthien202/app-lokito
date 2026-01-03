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

  // Diverse image URLs for posts - 50 unique images
  static final List<String> _imageUrls = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop', // Beach
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&h=400&fit=crop', // Food
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=400&fit=crop', // Office
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop', // Coffee/Tech
    'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?w=400&h=400&fit=crop', // Healthy food
    'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=400&h=400&fit=crop', // Music
    'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400&h=400&fit=crop', // Fitness
    'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?w=400&h=400&fit=crop', // Books
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&h=400&fit=crop', // Nature
    'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=400&fit=crop', // Restaurant
    'https://images.unsplash.com/photo-1551632811-561732d1e306?w=400&h=400&fit=crop', // Workout
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400&h=400&fit=crop', // Mountains
    'https://images.unsplash.com/photo-1493770348161-369560ae357d?w=400&h=400&fit=crop', // Food prep
    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400&h=400&fit=crop', // Music studio
    'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400&h=400&fit=crop', // Coding
    'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=400&fit=crop', // Travel
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=400&fit=crop', // Cooking
    'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=400&fit=crop', // Tech
    'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=400&fit=crop', // Breakfast
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop', // Healthy
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400&h=400&fit=crop', // Beach sunset
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=400&fit=crop', // Dinner
    'https://images.unsplash.com/photo-1497032205916-ac775f0649ae?w=400&h=400&fit=crop', // Business
    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=400&fit=crop', // Gym
    'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=400&fit=crop', // Adventure
    'https://images.unsplash.com/photo-1553979459-d2229ba7433a?w=400&h=400&fit=crop', // Smoothie
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop', // Concert
    'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=400&fit=crop', // AI/Tech
    'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?w=400&h=400&fit=crop', // Camping
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop', // Education
    'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=400&h=400&fit=crop', // Startup
    'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=400&h=400&fit=crop', // Baking
    'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=400&h=400&fit=crop', // Marathon
    'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=400&fit=crop', // Meditation
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=400&fit=crop', // Surfing
    'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=400&fit=crop', // AI Demo
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop', // Jazz
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop', // Vegan
    'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400&h=400&fit=crop', // Climbing
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop', // Book club
    'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=400&fit=crop', // Conference
    'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400&h=400&fit=crop', // Pizza
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop', // CrossFit
    'https://images.unsplash.com/photo-1540553016722-983e48a2cd10?w=400&h=400&fit=crop', // Spa
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400&h=400&fit=crop', // Diving
    'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=400&h=400&fit=crop', // ML
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=400&fit=crop', // Open mic
    'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=400&fit=crop', // Garden
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop', // Paragliding
    'https://images.unsplash.com/photo-1481349518771-20055b2a7b24?w=400&h=400&fit=crop', // PhD
  ];

  static List<PostModel> get posts {
    if (_showEmptyState) return [];
    
    return List.generate(50, (index) {
      final names = [
        'Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D', 'Hoàng Văn E',
        'Vũ Thị F', 'Đỗ Văn G', 'Bùi Thị H', 'Ngô Văn I', 'Lý Thị K',
        'Cao Văn L', 'Mai Thị M', 'Trương Văn N', 'Đinh Thị O', 'Phan Văn P',
        'Lưu Thị Q', 'Võ Văn R', 'Đặng Thị S', 'Hồ Văn T', 'Tô Thị U',
        'Lâm Văn V', 'Chu Thị W', 'Dương Văn X', 'Ông Thị Y', 'Kiều Văn Z',
        'Lại Thị AA', 'Mạc Văn BB', 'Ninh Thị CC', 'Ôn Văn DD', 'Phùng Thị EE',
        'Quách Văn FF', 'Rùa Thị GG', 'Sử Văn HH', 'Tạ Thị II', 'Ứng Văn JJ',
        'Vương Thị KK', 'Xa Văn LL', 'Yên Thị MM', 'Zung Văn NN', 'An Thị OO',
        'Bình Văn PP', 'Cúc Thị QQ', 'Đức Văn RR', 'Én Thị SS', 'Phúc Văn TT',
        'Giang Thị UU', 'Hạnh Văn VV', 'Ích Thị WW', 'Khánh Văn XX', 'Linh Thị YY'
      ];

      final contents = [
        'Một ngày tuyệt vời tại bãi biển! 🌊☀️ #beach #summer #vacation',
        'Bữa tối ngon miệng với gia đình 🍽️❤️ #family #dinner #homemade',
        'Văn phòng mới, năng lượng mới! 💼✨ #office #work #newbeginnings',
        'Thiên nhiên thật tuyệt vời! 🌲🏔️ #nature #hiking #mountains',
        'Coding session với cà phê ☕💻 #coding #coffee #developer',
        'Bữa sáng healthy để bắt đầu ngày mới! 🥗🍓 #healthy #breakfast #lifestyle',
        'Buổi tối thư giãn với âm nhạc 🎵🌙 #music #relax #evening',
        'Workout buổi sáng để có năng lượng cả ngày! 💪🏃‍♀️ #fitness #workout #morning',
        'Chuyến du lịch khám phá thành phố mới 🏙️✈️ #travel #city #explore',
        'Học hỏi những điều mới mỗi ngày 📚💡 #learning #books #knowledge',
        'Weekend getaway với bạn bè! 🏖️👫 #weekend #friends #fun',
        'Món ăn mới thử hôm nay! 🍜🔥 #food #delicious #newrecipe',
        'Dự án mới bắt đầu! 🚀💼 #project #work #startup',
        'Buổi chiều thư giãn với trà và sách 📖☕ #reading #tea #relax',
        'Chạy bộ buổi sáng để khỏe mạnh! 🏃‍♂️💪 #running #health #morning',
        'Yoga session để bắt đầu tuần mới 🧘‍♀️✨ #yoga #mindfulness #newweek',
        'Concert tuyệt vời tối qua! 🎸🎵 #concert #music #livemusic',
        'Picnic với gia đình cuối tuần 🧺🌳 #family #picnic #weekend',
        'Sunset đẹp tuyệt vời hôm nay! 🌅🌊 #sunset #beautiful #nature',
        'Workshop học tập thú vị! 📚💡 #workshop #learning #skills',
        'Hackathon 24h vừa kết thúc! 💻🏆 #hackathon #coding #winner',
        'Nấu ăn cùng mẹ cuối tuần 👩‍🍳❤️ #cooking #family #homemade',
        'Meeting thành công với khách hàng! 🤝💼 #business #meeting #success',
        'Gym session buổi tối hiệu quả! 💪🔥 #gym #fitness #strength',
        'Chuyến đi phượt miền núi tuyệt vời! 🏔️🏍️ #travel #mountains #adventure',
        'Smoothie bowl healthy cho bữa sáng! 🥣🍓 #healthy #breakfast #smoothie',
        'Buổi hòa nhạc cổ điển tuyệt vời! 🎼🎻 #classical #music #concert',
        'Code review session với team! 👨‍💻👩‍💻 #coding #teamwork #review',
        'Camping trip với bạn bè! ⛺🔥 #camping #friends #outdoor',
        'Khóa học online hoàn thành! 🎓💻 #education #online #certificate',
        'Startup pitch thành công! 🚀💡 #startup #pitch #entrepreneur',
        'Baking cookies cho cả nhà! 🍪👨‍👩‍👧‍👦 #baking #family #cookies',
        'Marathon 21km hoàn thành! 🏃‍♂️🏅 #marathon #running #achievement',
        'Meditation buổi sáng thư thái! 🧘‍♀️🌅 #meditation #morning #peace',
        'Surfing lesson đầu tiên! 🏄‍♂️🌊 #surfing #ocean #newexperience',
        'Hackathon AI project demo! 🤖💻 #AI #hackathon #innovation',
        'Jazz night tại quán quen! 🎷🌙 #jazz #music #nightlife',
        'Vegan meal prep cho tuần mới! 🥗🌱 #vegan #mealprep #healthy',
        'Rock climbing challenge hoàn thành! 🧗‍♂️⛰️ #climbing #challenge #adventure',
        'Book club meeting thú vị! 📚☕ #bookclub #reading #discussion',
        'Tech conference keynote speech! 🎤💻 #tech #conference #keynote',
        'Homemade pizza party! 🍕👨‍👩‍👧‍👦 #pizza #family #homemade',
        'CrossFit WOD hoàn thành! 💪🔥 #crossfit #workout #fitness',
        'Spa day thư giãn cuối tuần! 💆‍♀️✨ #spa #relax #selfcare',
        'Scuba diving adventure! 🤿🐠 #scubadiving #ocean #underwater',
        'Machine learning model deployed! 🤖📊 #ML #AI #deployment',
        'Open mic night performance! 🎤🎸 #openmic #music #performance',
        'Organic garden harvest! 🌱🥕 #organic #garden #harvest',
        'Paragliding adventure tuyệt vời! 🪂🏔️ #paragliding #adventure #flying',
        'PhD thesis defense thành công! 🎓📚 #PhD #thesis #graduation',
      ];

      final avatars = [
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=150&h=150&fit=crop&crop=face',
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150&h=150&fit=crop&crop=face',
      ];

      return PostModel(
        id: (index + 1).toString(),
        authorName: names[index],
        authorAvatar: avatars[index % avatars.length],
        imageUrl: _imageUrls[index],
        content: contents[index],
        isLiked: (index + 1) % 3 == 0,
        likes: ((index + 1) * 7) % 200 + 10,
        createdAt: DateTime.now().subtract(Duration(hours: 2 + index * 12)),
      );
    });
  }

  // Simulate more posts for pagination - not used anymore since we have 50 static posts
  static List<PostModel> getMorePosts(int page) {
    return []; // Return empty since we only want 50 posts total
  }
}