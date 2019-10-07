import 'User.dart';

class GitRepo {

  GitRepo({this.title, this.description, this.forks, this.stars, this.owner, this.pullRequestsUrl});

  final String title;
  final String description;
  final int forks;
  final int stars;
  final User owner;
  final pullRequestsUrl;

  factory GitRepo.fromJson(Map<String, dynamic> json) {
    return GitRepo(
      title: json["name"],
      description: json["description"] != null ? json["description"] : "",
      forks: json["forks"],
      stars: json["stargazers_count"],
      owner: User.fromJson(json["owner"]),
      pullRequestsUrl: json["pulls_url"]
    );
  }
}