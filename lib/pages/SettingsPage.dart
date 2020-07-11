import 'package:critic/pages/ContactPage.dart';
import 'package:critic/pages/TermsServicePage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/SideDrawer.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:critic/blocs/blockedUsers/Bloc.dart' as BLOCKED_USERS_BP;

import '../Constants.dart';
import '../ServiceLocator.dart';

class SettingsPage extends StatelessWidget {
  final Color _iconColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: _iconColor,
          ),
          title: Text('Logout'),
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');
            if (confirm) {
              //Clear stack of routes.
              while (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
              //Sign the user out and update the onAuth stream.
              await locator<AuthService>().signOut();
              print('Goodbye...');
            }
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.info_outline,
            color: _iconColor,
          ),
          title: Text('Terms & Service'),
          onTap: () async {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => TermsServicePage(),
            );
            Navigator.of(context).push(route);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.email,
            color: _iconColor,
          ),
          title: Text('Contact'),
          onTap: () async {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(),
            );
            Navigator.of(context).push(route);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.block,
            color: _iconColor,
          ),
          title: Text('Blocked Users'),
          onTap: () async {
            Route route = MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => BLOCKED_USERS_BP.BlockedUsersBloc()
                  ..add(
                    BLOCKED_USERS_BP.LoadPageEvent(),
                  ),
                child: BLOCKED_USERS_BP.BlockedUsersPage(),
              ),
            );

            Navigator.push(context, route);
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
