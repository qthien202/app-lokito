class AvatarUtils {
  // Avatar constants
  static const String _baseUrl = 'https://ui-avatars.com/api/';
  static const String _defaultBackground = '6366f1'; // Primary color
  static const String _defaultColor = 'ffffff'; // White text
  static const int _defaultSize = 200;
  static const bool _defaultBold = true;
  static const String _defaultFormat = 'png';
  
  /// Generate avatar URL with fallback to UI Avatars API
  static String getAvatarUrl({
    String? avatarUrl,
    String? name,
    String? email,
    String? username,
    int size = _defaultSize,
    String background = _defaultBackground,
    String color = _defaultColor,
  }) {
    // If custom avatar exists, use it
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }
    
    // Determine display name for fallback avatar
    final displayName = getDisplayName(
      name: name,
      username: username,
      email: email,
    );
    
    // Generate fallback avatar using UI Avatars API
    final encodedName = Uri.encodeComponent(displayName);
    
    return '$_baseUrl?name=$encodedName&size=$size&background=$background&color=$color&bold=$_defaultBold&format=$_defaultFormat';
  }
  
  /// Get display name from user data
  static String getDisplayName({
    String? name,
    String? username,
    String? email,
  }) {
    if (name != null && name.isNotEmpty) {
      return name;
    }
    if (username != null && username.isNotEmpty) {
      return username;
    }
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }
    return 'User';
  }
}