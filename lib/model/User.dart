class User {

  User({this.imageUrl, this.username, this.userUrl});

  final String imageUrl;
  final String username;
  String userUrl;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      imageUrl: json["avatar_url"] as String,
      username: json["login"] as String,
      userUrl: json["url"] as String
    );
  }
}