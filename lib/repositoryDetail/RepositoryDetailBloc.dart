import 'dart:async';

import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/model/PullRequest.dart';
import 'package:avocado_test/repositoryDetail/PRRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class RepositoryDetailBloc extends Bloc<PullListEvents, PullListState> {

  RepositoryDetailBloc({@required this.repository, this.gitRepo});

  final PRRepository repository;
  final GitRepo gitRepo;
  bool isLoading = false;

  PullListDataState _currentState = PullListState._data([], 0);

  @override
  PullListState get initialState => PullListState._loading();

  @override
  Stream<PullListState> mapEventToState(PullListEvents event) async* {
    if (event is LoadPullListEvent) {
      yield* _loadPRList(_currentState);
    }
  }

  Stream<PullListState> _loadPRList(PullListDataState currentState) async* {
    isLoading = true;
    final newPage = currentState.page + 1;
    final pullList = await repository.getPullRequests(gitRepo, newPage);
    if (pullList != null) {
      yield PullListState._data(pullList, newPage);
    } else {
      yield PullListState._error();
    }
    isLoading = false;
  }

}


@immutable
abstract class PullListState {
  PullListState();
  factory PullListState._data(List<PullRequest> list, int page) = PullListDataState;
  factory PullListState._loading() = PullListLoadingState;
  factory PullListState._error() = PullListError;
}

class PullListDataState extends PullListState {
  PullListDataState(this.list, this.page);
  final List<PullRequest> list;
  final int page;
}

class PullListError extends PullListState {
  final String message = "Unable to get next page";
}

class PullListLoadingState extends PullListState {}


@immutable
abstract class PullListEvents  {}

class LoadPullListEvent extends PullListEvents {
  @override
  String toString() => 'LoadPullList';
}