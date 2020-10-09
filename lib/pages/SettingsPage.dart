import 'package:critic/pages/ContactPage.dart';
import 'package:critic/pages/TermsServicePage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:critic/blocs/blockedUsers/Bloc.dart' as BLOCKED_USERS_BP;
import 'package:critic/blocs/allUsers/Bloc.dart' as ALL_USERS_BP;
import '../ServiceLocator.dart';

class SettingsPage extends StatelessWidget {
  final Color _iconColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'ACCOUNT SETTINGS',
          tiles: [
            SettingsTile(
              title: 'Blocked Users',
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
          ],
        ),
        SettingsSection(
          title: 'CONTACT US',
          tiles: [
            SettingsTile(
              title: 'Email',
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => ContactPage(),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'LEGAL',
          tiles: [
            SettingsTile(
              title: 'Terms of Service',
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => TermsServicePage(),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'ADMIN',
          tiles: [
            SettingsTile(
              title: 'All Users',
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ALL_USERS_BP.AllUsersBloc()
                      ..add(
                        ALL_USERS_BP.LoadPageEvent(),
                      ),
                    child: ALL_USERS_BP.AllUsersPage(),
                  ),
                );

                Navigator.push(context, route);
              },
            ),
          ],
        ),
        SettingsSection(
          tiles: [
            SettingsTile(
              title: 'Log Out',
              onTap: () async {
                bool confirm = await locator<ModalService>().showConfirmation(
                    context: context,
                    title: 'Logout',
                    message: 'Are you sure?');
                if (confirm) {
                  while (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  }
                  await locator<AuthService>().signOut();
                  print('Goodbye...');
                }
              },
            )
          ],
        )
      ],
    );
  }
}
