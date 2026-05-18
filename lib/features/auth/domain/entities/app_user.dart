class AppUser {
  AppUser({required this.userId, required this.username});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['userId'] as String,
      username: json['username'] as String,
    );
  }

  final String userId;
  final String username;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
      };
}
