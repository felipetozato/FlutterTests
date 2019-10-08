import 'package:avocado_test/model/User.dart';
import 'package:avocado_test/repositoryList/DartGitRepoRepository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {

  //This could be a mocked client. I just want to test the integration here as well
  //which transform this into a integration test...
  final http.Client client = http.Client();

  var repository = DartGitReporepository(client: client);

  test('Test getRepos, return valid result', () async {
    var repos = await repository.getRepos(1);
    
    expect(repos.length, 30);
    expect(repos[0].title, isNotEmpty);
    expect(repos[0].description, isNotEmpty);
    expect(repos[0].forks, isNotNull);
    expect(repos[0].stars, isNotNull);
    expect(repos[0].pullRequestsUrl, isNotEmpty);
    expect(repos[0].owner, isA<User>());
  });
}