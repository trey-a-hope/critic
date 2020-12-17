import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/blockedUsers/Bloc.dart' as BLOCKED_USERS_BP;

class BlockedUsersPage extends StatefulWidget {
  @override
  State createState() => BlockedUsersPageState();
}

class BlockedUsersPageState extends State<BlockedUsersPage>
    implements BLOCKED_USERS_BP.BlockedUsersBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BLOCKED_USERS_BP.BlockedUsersBloc _blockedUsersBloc;
  @override
  void initState() {
    _blockedUsersBloc =
        BlocProvider.of<BLOCKED_USERS_BP.BlockedUsersBloc>(context);
    _blockedUsersBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Blocked Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BLOCKED_USERS_BP.BlockedUsersBloc,
          BLOCKED_USERS_BP.BlockedUsersState>(
        builder: (context, state) {
          if (state is BLOCKED_USERS_BP.LoadingState) {
            return Spinner();
          }

          if (state is BLOCKED_USERS_BP.NoBlockedUsersState) {
            return Center(
              child: Text('You have no blocked users...',
                  style: Theme.of(context).textTheme.headline5),
            );
          }

          if (state is BLOCKED_USERS_BP.FoundBlockUsersState) {
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final UserModel user = state.users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imgUrl),
                          ),
                          title: Text(
                            '${user.username}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          subtitle: Text(
                            '${user.email}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onTap: () async {
                            final bool confirm = await locator<ModalService>()
                                .showConfirmation(
                                    context: context,
                                    title: 'Unblock ${user.username}',
                                    message: 'Are you sure?');

                            if (!confirm) return;

                            _blockedUsersBloc.add(
                              BLOCKED_USERS_BP.UnblockUserEvent(
                                  userID: user.uid),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Text(
                    'These user\s will not show on your timeline.',
                    style: TextStyle(color: Theme.of(context).textTheme.headline6.color),
                  ),
                ],
              ),
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
