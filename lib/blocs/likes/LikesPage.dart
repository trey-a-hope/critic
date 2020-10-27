import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:critic/blocs/likes/Bloc.dart' as LIKES_BP;

class LikesPage extends StatefulWidget {
  @override
  State createState() => LikesPageState();
}

class LikesPageState extends State<LikesPage>
    implements LIKES_BP.LikesBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LIKES_BP.LikesBloc _likesBloc;

  @override
  void initState() {
    _likesBloc = BlocProvider.of<LIKES_BP.LikesBloc>(context);
    _likesBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: COLOR_NAVY,
        title: Text(
          'Likes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LIKES_BP.LikesBloc, LIKES_BP.LikesState>(
        builder: (context, state) {
          if (state is LIKES_BP.LoadingState) {
            return Spinner();
          }

          if (state is LIKES_BP.LoadedState) {
            final List<UserModel> likeUsers = state.likeUsers;

            if (likeUsers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.grey,
                    ),
                    Text(
                      'No likes at this moment.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Come back later.')
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: likeUsers.length,
                itemBuilder: (context, index) {
                  final UserModel likeUser = likeUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(likeUser.imgUrl),
                    ),
                    title: Text('${likeUser.username}'),
                    subtitle: Text('${likeUser.email}'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              OTHER_PROFILE_BP.OtherProfileBloc(
                            otherUserID: likeUser.uid,
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
