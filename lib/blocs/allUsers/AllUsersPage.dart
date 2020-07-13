import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/allUsers/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllUsersPage extends StatefulWidget {
  @override
  State createState() => AllUsersPageState();
}

class AllUsersPageState extends State<AllUsersPage>
    implements AllUsersBlocDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AllUsersBloc _allUsersBloc;

  @override
  void initState() {
    _allUsersBloc = BlocProvider.of<AllUsersBloc>(context);
    _allUsersBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'All Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AllUsersBloc, AllUsersState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is LoadedState) {
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
                  onTap: () async {
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
