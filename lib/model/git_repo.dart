import 'user.dart';

class GitRepo {

  GitRepo({this.id, this.title, this.description, this.forks, this.stars, this.owner, this.pullRequestsUrl});

  final int id;
  final String title;
  final String description;
  final int forks;
  final int stars;
  final User owner;
  final String pullRequestsUrl;

  factory GitRepo.fromJson(Map<String, dynamic> json) {
    return GitRepo(
      id: json["id"],
      title: json["name"],
      description: json["description"] != null ? json["description"] : "",
      forks: json["forks"],
      stars: json["stargazers_count"],
      owner: User.fromJson(json["owner"]),
      pullRequestsUrl: json["pulls_url"]
    );
  }
}