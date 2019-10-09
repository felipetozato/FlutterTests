import 'package:avocado_test/app_localization.dart';
import 'package:avocado_test/commons/widgets/circular_image_widget.dart';
import 'package:avocado_test/commons/widgets/loading_widgety.dart';
import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/repository_detail/repository_detail_page.dart';
import 'package:avocado_test/repositoryList/dart_github_repository.dart';
import 'package:avocado_test/repositoryList/dart_github_list_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DartGithubListPage extends StatefulWidget {

  DartGithubListPage({Key key, this.repository}) : super(key: key);

  final DartGithubRepository repository;

  @override
  State<StatefulWidget> createState() => _RepositoryListPage();
}

class _RepositoryListPage extends State<DartGithubListPage> {

  DartGithubListBloc _bloc;

  bool _isLoading = false;

  void _onItemListClick(GitRepo repository) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RepositoryDetailPage(gitRepo: repository))
    );
  }

  @override
  void initState() {
    _bloc = DartGithubListBloc(repository: widget.repository);
    _bloc.dispatch(LoadRepositoryListEvent());
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, RepositoryListState state) {
        var isLoading = state is RepositoryListLoadingState;

        return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).title),
              automaticallyImplyLeading: true,
            ),
            drawer: Drawer(),
            body: Theme(
                data: Theme.of(context),
                //child: _listView(context),
                child: isLoading ? LoadingWidget() :
                _buildContent(context, (state as RepositoryListDataState).list)
            )
        );
      }
    );
  }

  Widget _buildContent(BuildContext context, List<GitRepo> repoList) {
    _isLoading = false;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading && scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent) {
          _isLoading = true;
          _bloc.dispatch(LoadRepositoryListEvent());
        }
        return true;
      },
      child: ListView.separated(
        itemCount: repoList.length,
        separatorBuilder: (context, index) {
          return Divider(color: Colors.black);
        },
        itemBuilder: (context, index) {
          return _listItem(context, repoList[index]);
        }
      ),
    );
  }

  Widget _listItem(BuildContext context, GitRepo repository) {
    return InkWell(
      onTap: () => _onItemListClick(repository),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(repository.title,
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.left),
                    Text(repository.description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.start),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Image.asset('images/icon_fork.png', color: Colors.orange,
                              height: 22.0, width: 22.0),
                          Text(repository.forks.toString(),
                              style: Theme.of(context).textTheme.caption),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 4.0, 0.0),
                            child: Icon(Icons.star, size: 22.0, color: Colors.orange),
                          ),
                          Text(repository.stars.toString(), style: Theme.of(context).textTheme.caption)
                        ],
                      ),
                    )
                  ]
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(            
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularImage(repository.owner.imageUrl),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0),
                    child: Text(repository.owner.username,
                        style: Theme.of(context).textTheme.subtitle
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      )
    );
  }
}