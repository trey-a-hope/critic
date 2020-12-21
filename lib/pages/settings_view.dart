import 'package:critic/main.dart';
import 'package:critic/pages/ContactPage.dart';
import 'package:critic/pages/terms_service_view.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:critic/blocs/blockedUsers/Bloc.dart' as BLOCKED_USERS_BP;
import 'package:shared_preferences/shared_preferences.dart';
import '../ServiceLocator.dart';

class SettingsView extends StatefulWidget {
  final MyAppState myAppState;
  SettingsView({@required this.myAppState});

  @override
  State createState() => SettingsViewState(myAppState: myAppState);
}

class SettingsViewState extends State<SettingsView> {
  SettingsViewState({@required this.myAppState});
  final MyAppState myAppState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Account Settings'.toUpperCase(),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ListTile(
          title: Text(
            'Blocked Users',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: () {
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
        ListTile(
          title: Text(
            'Dark/Light Mode',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: DayNightSwitcher(
            isDarkModeEnabled: this.myAppState.isDarkModeEnabled,
            onStateChanged: (bool isDarkModeEnabled) async {
              print('${this.myAppState.isDarkModeEnabled}');
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);

              this.myAppState.setState(() {
                this.myAppState.isDarkModeEnabled = isDarkModeEnabled;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Contact Us'.toUpperCase(),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ListTile(
          title: Text(
            'Email',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => ContactPage(),
            );
            Navigator.of(context).push(route);
          },
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Legal'.toUpperCase(),
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        ListTile(
          title: Text(
            'Terms of Service',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) => TermsServicePage(),
            );
            Navigator.of(context).push(route);
          },
        ),
        ListTile(
          title: Text(
            'Logout',
            style: Theme.of(context).textTheme.headline4,
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).iconTheme.color,
          ),
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Logout', message: 'Are you sure?');
            if (confirm) {
              while (Navigator.of(context).canPop()) {
                Navigator.pop(context);
              }
              await locator<AuthService>().signOut();
              print('Goodbye...');
            }
          },
        ),
      ],
    );
  }
}
