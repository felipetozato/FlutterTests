import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/model/PullRequest.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PRRepository {

  PRRepository({this.client});

  final http.Client client;

  Future<List<PullRequest>> getPullRequests(GitRepo repository, int page) async {
    try {
      var url = repository.pullRequestsUrl.replaceAll('{/number}', '') + "?page=$page";
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(res.body) as List;
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