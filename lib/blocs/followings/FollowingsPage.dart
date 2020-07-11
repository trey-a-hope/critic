import 'package:critic/blocs/followers/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;

import '../../ServiceLocator.dart';
import 'Bloc.dart' as FOLLOWINGS_BP;

class FollowingsPage extends StatefulWidget {
  @override
  State createState() => FollowingsPageState();
}

class FollowingsPageState extends State<FollowingsPage>
    implements FOLLOWINGS_BP.FollowingsBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FOLLOWINGS_BP.FollowingsBloc _followingsBloc;

  @override
  void initState() {
    _followingsBloc = BlocProvider.of<FOLLOWINGS_BP.FollowingsBloc>(context);
    _followingsBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Following',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FOLLOWINGS_BP.FollowingsBloc,
          FOLLOWINGS_BP.FollowingsState>(
        builder: (context, state) {
          if (state is FOLLOWINGS_BP.LoadingState) {
            return Spinner();
          }

          if (state is FOLLOWINGS_BP.NoFollowingsState) {
            return Center(
              child: Text('You are not following anyone...'),
            );
          }

          if (state is FOLLOWINGS_BP.FoundFollowingsState) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel user = state.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imgUrl),
                  ),
                  title: Text('${user.username}'),
                  subtitle: Text('${user.email}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
                          otherUserID: user.uid,
                        )..add(
                            OTHER_PROFILE_BP.LoadPageEvent(),
                          ),
                        child: OTHER_PROFILE_BP.OtherProfilePage(),
                      ),
                    );

                    Navigator.push(context, route);
                  },
                );
              },
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
  void showMessage({@required String message}) {
    locator<ModalService>().showInSnackBar(
      scaffoldKey: _scaffoldKey,
      message: message,
    );
  }
}
