import 'dart:async';

import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/model/PullRequest.dart';
import 'package:avocado_test/repositoryDetail/PRRepository.dart';

class RepositoryDetailBloc {

  RepositoryDetailBloc(this._repository, this._gitRepo);

  final PRRepository _repository;
  final GitRepo _gitRepo;
  final _listController = StreamController<PullListState>();
  int _page = 1;
  bool isLoading = false;

  Stream<PullListState> get pullList => _listController.stream;
  PullListDataState _currentState = PullListDataState([]);

  void loadPRList() {
    isLoading = true;
    _repository.getPullRequests(_gitRepo, _page).then((list) {
      if (list != null) {
        _currentState = PullListState._data(_currentState.list + list);
        _listController.sink.add(_currentState);
        _page++;
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

class PullListState {
  PullListState();
  factory PullListState._data(List<PullRequest> list) = PullListDataState;
  factory PullListState._loading() = PullListLoadingstate;
}

class PullListDataState extends PullListState {
  PullListDataState(this.list);
  final List<PullRequest> list;
}

class PullListLoadingstate extends PullListState {}