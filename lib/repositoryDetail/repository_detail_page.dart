import 'package:avocado_test/commons/widgets/circular_image_widget.dart';
import 'package:avocado_test/commons/widgets/loading_widgety.dart';
import 'package:avocado_test/model/pull_request.dart';
import 'package:avocado_test/model/git_repo.dart';
import 'package:avocado_test/repositoryDetail/pr_repository.dart';
import 'package:avocado_test/repositoryDetail/repository_detail_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RepositoryDetailPage extends StatefulWidget {

  RepositoryDetailPage({Key key, this.gitRepo}) : super(key: key);

  final GitRepo gitRepo;

  //TODO DI this kind of thing. Better if directly to the Bloc class. Not sure if I will have time to mess with DI
  final PRRepository prRepository = PRRepository(client: http.Client());

  @override
  State<StatefulWidget> createState() => _RepositoryDetailPage();
}

class _RepositoryDetailPage extends State<RepositoryDetailPage> {

  RepositoryDetailBloc _bloc;
  bool _isLoading = false;

  final DateFormat dateFormat = DateFormat("hh:mm dd/MM/yyyy");

  void _onItemListClick(PullRequest pr) async {    
    if (await canLaunch(pr.url)) {
      await launch(pr.url);
    } else {
      throw 'Could not launch ${pr.url}';
    }
  }

  @override
  void initState() {
    _bloc = RepositoryDetailBloc(repository: widget.prRepository, gitRepo: widget.gitRepo);
    _bloc.dispatch(LoadPullListEvent());
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
      builder: (BuildContext context, PullListState state) {

        var isLoading = state is PullListLoadingState;

        return Scaffold(
            appBar: AppBar(
                title: Text(widget.gitRepo.title),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                )
            ),
            drawer: Drawer(),
            body: Theme(
                data: Theme.of(context),
                child: isLoading ? LoadingWidget() :
                _buildContent(context, state as PullListDataState)
            )
        );
      }
    );
  }

  Widget _buildContent(BuildContext context, PullListDataState data) {
    var list = data.list;
    _isLoading = false;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _isLoading = true;
          _bloc.dispatch(LoadPullListEvent());
          return true;
        }
        return false;
      },
      child: ListView.separated(
        itemCount: data.list.length + 1,
        separatorBuilder: (context, index) {
          if (index == 0) {
            return Container();
          }
          return Divider(color: Colors.black);
        },
        itemBuilder: (context, index) {
          // show header
          if (index == 0) {
            return _listHeader(context, list.length);
          }
          return _listItem(context, list[index-1]);
        }
      )
    );
  }

  Widget _listItem(BuildContext context, PullRequest pr) {
    return InkWell(
        onTap: () => _onItemListClick(pr),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  dateFormat.format(pr.createdAt),
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              Text(
                pr.title,
                style: Theme.of(context).textTheme.title,
                textAlign: TextAlign.left
              ),
              Text(
                pr.body,
                style: Theme.of(context).textTheme.body1,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircularImage(pr.user.imageUrl),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(pr.user.username,
                          style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 18.0)
                        ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _listHeader(BuildContext context, int opened) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //TODO internationalize strings
          Text("$opened opened",
            style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.normal)
          )
      ]),
    );
  }
}