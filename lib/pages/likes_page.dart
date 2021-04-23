import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/UserListTile.dart';
import 'package:flutter/material.dart';

class LikesPage extends StatefulWidget {
  final List<UserModel> likedUsers;

  LikesPage({@required this.likedUsers});

  @override
  State createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
      body: widget.likedUsers.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: widget.likedUsers.length,
              itemBuilder: (context, index) {
                final UserModel likeUser = widget.likedUsers[index];
                return UserListTile(user: likeUser);
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
