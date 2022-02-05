import 'package:critic/blocs/suggestions/suggestions_bloc.dart';
import 'package:critic/main.dart';
import 'package:critic/pages/contact_page.dart';
import 'package:critic/pages/terms_service_view.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service_locator.dart';

class SettingsView extends StatefulWidget {
  SettingsView();

  @override
  State createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  SettingsViewState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(10),
          //   child: Text(
          //     'Account Settings'.toUpperCase(),
          //     style: Theme.of(context).textTheme.headline5,
          //   ),
          // ),
          // ListTile(
          //   title: Text(
          //     'Dark/Light Mode',
          //     style: Theme.of(context).textTheme.headline4,
          //   ),
          //   trailing: DayNightSwitcher(
          //     isDarkModeEnabled: this.myAppState.isDarkModeEnabled,
          //     onStateChanged: (bool isDarkModeEnabled) async {
          //       print('${this.myAppState.isDarkModeEnabled}');
          //       final SharedPreferences prefs =
          //           await SharedPreferences.getInstance();
          //
          //       prefs.setBool('isDarkModeEnabled', isDarkModeEnabled);
          //
          //       this.myAppState.setState(() {
          //         this.myAppState.isDarkModeEnabled = isDarkModeEnabled;
          //       });
          //     },
          //   ),
          // ),
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
          ListTile(
            title: Text(
              'Leave a Suggestion',
              style: Theme.of(context).textTheme.headline4,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SuggestionsBloc()..add(LoadPageEvent()),
                  child: SuggestionsView(),
                ),
              );

              Navigator.push(context, route);
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
              bool? confirm = await locator<ModalService>().showConfirmation(
                  context: context, title: 'Logout', message: 'Are you sure?');
              if (confirm == null || confirm) {
                while (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                }
                await locator<AuthService>().signOut();
                print('Goodbye...');
              }
            },
          ),
        ],
      ),
    );
  }
}
