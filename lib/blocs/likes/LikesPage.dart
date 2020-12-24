import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:critic/widgets/UserListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: likeUsers.length,
                itemBuilder: (context, index) {
                  final UserModel likeUser = likeUsers[index];
                  return UserListTile(user: likeUser);
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
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
