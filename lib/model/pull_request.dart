import 'user.dart';

class PullRequest {

  PullRequest({this.url, this.title, this.body, this.user, this.createdAt});

  final String title;
  final String body;
  final User user;
  final String url;
  final DateTime createdAt;

  factory PullRequest.fromJson(Map<String, dynamic> json) {
    return PullRequest(
      url: json["html_url"],
      title: json["title"],
      body: json["body"],
      createdAt: DateTime.parse(json["created_at"]),
      user: User.fromJson(json["user"])
    );
  }
}