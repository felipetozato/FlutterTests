import 'package:avocado_test/model/git_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DartGithubRepository {

  DartGithubRepository({this.client});

  final http.Client client;

  final String _url = "https://api.github.com/search/repositories?q=language:Dart&sort=stars&page=";

  Future<List<GitRepo>> getRepos(int page) async {
    try {
      var res = await http.get(_url + page.toString());
      if (res.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(res.body);
        var items = jsonResponse['items'] as List;
        return items.map((json) => GitRepo.fromJson(json)).toList();
      } {
        print("Request failed with status: ${res.statusCode}.");
        return null; // Maybe throw exception for better error handling.
      }
    } catch (e) {
      print("Request failed with status: ${e.toString()}.");
      return null; // Maybe throw exception for better error handling.
    }  
  }
}