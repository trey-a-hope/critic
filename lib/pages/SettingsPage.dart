import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final IModalService modalService = GetIt.I<IModalService>();
  final IAuthService authService = GetIt.I<IAuthService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () async {
            bool confirm = await modalService.showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');
            if (confirm) {
              //Clear stack of routes.
              while (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
              //Sign the user out and update the onAuth stream.
              await authService.signOut();
              print('Goodbye...');
            }
          },
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'v. $version',
            style: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
