import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/blocs/followers/Bloc.dart' as FOLLOWERS_BP;

import 'package:pagination/pagination.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FollowersPage extends StatefulWidget {
  @override
  State createState() => FollowersPageState();
}

class FollowersPageState extends State<FollowersPage>
    implements FOLLOWERS_BP.FollowersBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FOLLOWERS_BP.FollowersBloc _followersBloc;

  @override
  void initState() {
    _followersBloc = BlocProvider.of<FOLLOWERS_BP.FollowersBloc>(context);
    _followersBloc.setDelegate(delegate: this);
    super.initState();
  }

  Future<List<UserModel>> pageFetch(int offset) async {
    //Fetch template documents.
    List<UserModel> users =
        await locator<UserService>().retrieveFollowersFromStream(
      limit: _followersBloc.limit,
      offset: offset,
      uid: _followersBloc.user.uid,
    );

    return users;
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
      body:
          BlocBuilder<FOLLOWERS_BP.FollowersBloc, FOLLOWERS_BP.FollowersState>(
        builder: (context, state) {
          if (state is FOLLOWERS_BP.LoadingState) {
            return Spinner();
          }

          if (state is FOLLOWERS_BP.LoadedState) {
            return PaginationList<UserModel>(
              onLoading: Spinner(),
              onPageLoading: Spinner(),
              separatorWidget: Divider(),
              itemBuilder: (BuildContext context, UserModel user) {
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
              pageFetch: pageFetch,
              onError: (dynamic error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              onEmpty: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No followers at this moment.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Come back later.')
                  ],
                ),
              ),
            );
          }

          // if (state is NoFollowersState) {
          //   return Center(
          //     child: Text('You have no followers...'),
          //   );
          // }

          // if (state is FoundFollowersState) {
          //   return ListView.builder(
          //     itemCount: state.users.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       final UserModel user = state.users[index];
          //       return ListTile(
          //         leading: CircleAvatar(
          //           backgroundImage: NetworkImage(user.imgUrl),
          //         ),
          //         title: Text('${user.username}'),
          //         subtitle: Text('${user.email}'),
          //         trailing: Icon(Icons.chevron_right),
          //         onTap: () {
          //           Route route = MaterialPageRoute(
          //             builder: (context) => BlocProvider(
          //               create: (context) => OTHER_PROFILE_BP.OtherProfileBloc(
          //                 otherUserID: user.uid,
          //               )..add(
          //                   OTHER_PROFILE_BP.LoadPageEvent(),
          //                 ),
          //               child: OTHER_PROFILE_BP.OtherProfilePage(),
          //             ),
          //           );

          //           Navigator.push(context, route);
          //         },
          //       );
          //     },
          //   );
          // }

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
