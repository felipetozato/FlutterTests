import 'dart:async';

import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/repository_list/dart_github_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class DartGithubListBloc extends Bloc<RepositoryListEvent, RepositoryListState> {
  DartGithubListBloc();

  //TODO maybe to some DI with library with automatic parsing. I haven't looked how DI can be done in dart.
  final DartGithubRepository repository = DartGithubRepository(http.Client());

  @override
  RepositoryListState get initialState => RepositoryListState._loading();

  @override
  Stream<RepositoryListState> mapEventToState(RepositoryListEvent event) async* {
    if (event is LoadRepositoryListEvent) {
      var currentDataState = this.currentState is RepositoryListDataState ?
        (this.currentState as RepositoryListDataState) : RepositoryListDataState.initial();
      yield* _loadGitRepositories(currentDataState);
    }
  }

  Stream<RepositoryListState> _loadGitRepositories(RepositoryListDataState currentState) async* {
    var nextPage = currentState.page + 1;
    var list = await repository.getRepos(nextPage);
    print("Loaded page: $nextPage");
    yield list != null ?
      RepositoryListState._data(currentState.list + list, nextPage) :
      RepositoryListState._error();
  }

}

@immutable
abstract class RepositoryListState {
  RepositoryListState();
  factory RepositoryListState._data(List<GitRepo> list, int page) = RepositoryListDataState;
  factory RepositoryListState._loading() = RepositoryListLoadingState;
  factory RepositoryListState._error() = RepositoryListErrorState;
}

class RepositoryListDataState extends RepositoryListState {
  RepositoryListDataState(this.list, this.page);
  final List<GitRepo> list;
  final int page;

  factory RepositoryListDataState.initial() => RepositoryListDataState([], 0);
}

class RepositoryListLoadingState extends RepositoryListState {}
class RepositoryListErrorState extends RepositoryListState {
  final String message = "Unable to get next page";
}

@immutable
abstract class RepositoryListEvent {}

class LoadRepositoryListEvent extends RepositoryListEvent {
  @override
  String toString() => 'LoadRepositoryListEvent';
}