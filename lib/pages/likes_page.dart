import 'package:critic/service_locator.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';

class LikesPage extends StatefulWidget {
  final List<UserModel> likedUsers;

  LikesPage({required this.likedUsers});

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

  void showMessage({
    required String message,
  }) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
