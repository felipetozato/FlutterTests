import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/model/user.dart';
import 'package:avocado_test/repository_detail/pr_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {

  //This could be a mocked client. I just want to test the integration here as well
  //which transform this into a integration test...
  final http.Client client = http.Client();

  var repository = PRRepository(client: client);

  test('Test getRepos, return valid result', () async {

    var user = User();
    var repo = GitRepo(id: 1234, title: "flutter", description: "Flutter makes it easy an… beautiful mobile apps.",
        forks: 4, stars: 2000, owner: user, pullRequestsUrl: "https://api.github.com/repos/flutter/flutter/pulls{/number}");

    var prList = await repository.getPullRequests(repo, 1);

    expect(prList.length, 30);
    expect(prList[0].title, isNotEmpty);
    expect(prList[0].body, isNotEmpty);
    expect(prList[0].createdAt, isNotNull);
    expect(prList[0].url, isNotNull);
    expect(prList[0].user, isA<User>());
  });
}