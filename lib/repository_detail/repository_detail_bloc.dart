import 'dart:async';

import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/model/pull_request.dart';
import 'package:avocado_test/repository_detail/pr_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class RepositoryDetailBloc extends Bloc<PullListEvents, PullListState> {

  RepositoryDetailBloc({this.gitRepo});

  //TODO DI this kind of thing. Better if directly to the Bloc class. Not sure if I will have time to mess with DI
  final PRRepository repository = PRRepository(client: http.Client());
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