import 'dart:async';

import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/repositoryList/DartGitRepoRepository.dart';

class RepositoryListBloc {

  //TODO maybe to some DI with library with automatic parsing. I haven't looked how DI can be done in dart.
  RepositoryListBloc(this._repository);

  final DartGitReporepository _repository;
  final _listController = StreamController<GitRepoState>();
  int _page = 1;
  bool isLoading = false;

  Stream<GitRepoState> get repoList => _listController.stream;
  GitRepoDataState _currentState = GitRepoDataState([]);

  void loadGitRepositories() {
    isLoading = true;
    _repository.getRepos(_page).then((list) {
      if (list != null) {
        _currentState = GitRepoState._data(_currentState.list + list);
        _page++;
        _listController.sink.add(_currentState);
      } else {
        _listController.sink.addError("Error while retrieving repositories");
      }
      isLoading = false;
    });
  }

  void dispose() {
    _listController.close();
  }

}

class GitRepoState {
  GitRepoState();
  factory GitRepoState._data(List<GitRepo> list) = GitRepoDataState;
  factory GitRepoState._loading() = GitRepoLoadingstate;
}

class GitRepoDataState extends GitRepoState {
  GitRepoDataState(this.list);
  final List<GitRepo> list;
}

class GitRepoLoadingstate extends GitRepoState {}