import 'package:avocado_test/model/GitRepo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DartGitReporepository {

  final String _url = "https://api.github.com/search/repositories?q=language:Dart&sort=stars&page=";

  Future<List<GitRepo>> getRepos(int page) async {
    try {
      var res = await http.get(_url + page.toString());
      if (res.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(res.body);
        var items = jsonResponse['items'] as List;
        print("Number of repos: $items.length");
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