class AppUser {
  final String userId;
  final String username;

  AppUser({
    required this.userId,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      userId: jsonUser['userId'],
      username: jsonUser['username'],
    );
  }
}