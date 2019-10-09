import 'dart:async';

import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/model/pull_request.dart';
import 'package:avocado_test/repositoryDetail/pr_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class RepositoryDetailBloc extends Bloc<PullListEvents, PullListState> {

  //TODO maybe to some DI with library with automatic parsing. I haven't looked how DI can be done in dart.
  RepositoryDetailBloc({@required this.repository, this.gitRepo});

  final PRRepository repository;
  final GitRepo gitRepo;

  @override
  PullListState get initialState => PullListState._loading();

  @override
  Stream<PullListState> mapEventToState(PullListEvents event) async* {
    if (event is LoadPullListEvent) {
      var currentDataState = this.currentState is PullListDataState ?
        (this.currentState as PullListDataState) : PullListDataState.initial();
      yield* _loadPRList(currentDataState);
    }
  }

  Stream<PullListState> _loadPRList(PullListDataState currentState) async* {
    final newPage = currentState.page + 1;
    final pullList = await repository.getPullRequests(gitRepo, newPage);
    if (pullList != null) {
      yield PullListState._data(currentState.list + pullList, newPage);
    } else {
      yield PullListState._error();
    }
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

  factory PullListDataState.initial() => PullListDataState([], 0);
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