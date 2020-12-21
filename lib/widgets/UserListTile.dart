import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({@required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.imgUrl),
      ),
      title: Text(
        '${user.username}',
        style: Theme.of(context).textTheme.headline4,
      ),
      subtitle: Text(
        '${user.email}',
        style: Theme.of(context).textTheme.headline5,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).iconTheme.color,
      ),
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
  }
}
