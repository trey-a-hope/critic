import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/web/Bloc.dart' as WEB_BP;
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class WebPage extends StatefulWidget {
  @override
  State createState() => WebPageState();
}

class WebPageState extends State<WebPage> implements WEB_BP.WebBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  WEB_BP.WebBloc _webBloc;
  @override
  void initState() {
    _webBloc = BlocProvider.of<WEB_BP.WebBloc>(context);
    _webBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton.extended(
        label: Row(children: [
          Icon(Icons.help),
          SizedBox(
            width: 10,
          ),
          Text('Help')
        ]),
        //child: Icon(Icons.add),
        onPressed: () {},
      ),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //   title: Text(
      //     'Blocked Users',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: BlocBuilder<WEB_BP.WebBloc, WEB_BP.WebState>(
        builder: (context, state) {
          if (state is WEB_BP.LoadingState) {
            return Spinner();
          }

          if (state is WEB_BP.LoadedState) {
            final List<UserModel> topFiveRecentUsers = state.topFiveRecentUsers;
            final List<UserModel> topFiveCritiquesUsers =
                state.topFiveCritiquesUsers;

            return ListView(
              children: [
                Container(
                  height: 300,
                  color: Colors.red.shade900,
                  child: Center(
                    child: Text(
                      'Welcome To Critic',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recently Joined Users',
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: topFiveRecentUsers.map(
                            (user) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    tileColor: Colors.grey.shade400,
                                    leading: CachedNetworkImage(
                                      imageUrl: '${user.imgUrl}',
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    title: Text(user.username),
                                    subtitle: Text(
                                        '${timeago.format(user.created, allowFromNow: true)} on ${DateFormat('MMM dd, yyyy').format(user.created)}'),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                        Text(
                          'Users With Most Critiques',
                          textAlign: TextAlign.start,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: topFiveCritiquesUsers.map(
                            (user) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    tileColor: Colors.grey.shade400,
                                    leading: CachedNetworkImage(
                                      imageUrl: '${user.imgUrl}',
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    title: Text(user.username),
                                    subtitle:
                                        Text('${user.critiqueCount} critiques'),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }

          if (state is WEB_BP.ErrorState) {
            return Center(
              child: Text('Error: ${state.error.toString()}'),
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void showMessage({
    @required String message,
  }) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
