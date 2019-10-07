import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/model/PullRequest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PRRepository {

  Future<List<PullRequest>> getPullRequests(GitRepo repository, int page) async {
    try {
      var url = repository.pullRequestsUrl.replaceAll('{/number}', '') + "?page=$page";
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(res.body) as List;
        print("Number of repos: $jsonResponse.length");
        return jsonResponse.map((json) => PullRequest.fromJson(json)).toList();
      } {
        print("Request failed with status: ${res.statusCode}.");
        return null; // Maybe throw exception for better error handling.
      }
    } catch (e) {
      print("Request failed with exception: ${e.toString()}.");
      return null;
    }
  }
}