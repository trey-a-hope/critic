import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/followers/FollowersState.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'FollowersBloc.dart';

class FollowersPage extends StatefulWidget {
  @override
  State createState() => FollowersPageState();
}

class FollowersPageState extends State<FollowersPage>
    implements FollowersBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FollowersBloc _followersBloc;
  @override
  void initState() {
    _followersBloc = BlocProvider.of<FollowersBloc>(context);
    _followersBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Followers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FollowersBloc, FollowersState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is NoFollowersState) {
            return Center(
              child: Text('You have no followers...'),
            );
          }

          if (state is FoundFollowersState) {
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
  void showMessage({
    @required String message,
  }) {
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
