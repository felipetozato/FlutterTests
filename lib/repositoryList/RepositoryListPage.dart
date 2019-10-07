import 'package:avocado_test/commons/widgets/CircularImageWidget.dart';
import 'package:avocado_test/commons/widgets/LoadingWidget.dart';
import 'package:avocado_test/model/GitRepo.dart';
import 'package:avocado_test/model/User.dart';
import 'package:avocado_test/repositoryDetail/RepositoryDetailPage.dart';
import 'package:avocado_test/repositoryList/DartGitRepoRepository.dart';
import 'package:avocado_test/repositoryList/RepositoryListBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RepositoryListPage extends StatefulWidget {

  RepositoryListPage({Key key, this.repository}) : super(key: key);

  final DartGitReporepository repository;

  @override
  State<StatefulWidget> createState() => _RepositoryListPage();
}

class _RepositoryListPage extends State<RepositoryListPage> {

  RepositoryListBloc _bloc;

  void _onItemListClick(GitRepo repository) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RepositoryDetailPage(gitRepo: repository))
    );
  }

  @override
  void initState() {
    _bloc = RepositoryListBloc(widget.repository);
    _bloc.loadGitRepositories();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Dart Repo'), //TODO Localize
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(),
      body: Theme(
        data: Theme.of(context),
        //child: _listView(context),
        child: SafeArea(
          child: StreamBuilder<GitRepoState>(stream: _bloc.repoList,
            initialData: GitRepoLoadingstate(),
            builder: (context, snapshot) {
              if (snapshot.data is GitRepoLoadingstate) {
                return LoadingWidget();
              }
              if (snapshot.data is GitRepoDataState) {
                return _buildContent(context, (snapshot.data as GitRepoDataState).list);
              }
            }
          )
        )
      )
    );
  }

  Widget _buildContent(BuildContext context, List<GitRepo> repoList) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_bloc.isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _bloc.loadGitRepositories();
        }
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