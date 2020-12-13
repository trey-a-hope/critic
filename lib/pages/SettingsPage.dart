import 'package:critic/pages/ContactPage.dart';
import 'package:critic/pages/TermsServicePage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:critic/blocs/blockedUsers/Bloc.dart' as BLOCKED_USERS_BP;
import '../ServiceLocator.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'ACCOUNT SETTINGS',
          tiles: [
            SettingsTile(
              title: 'Blocked Users',
              onPressed: (BuildContext context) {
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
              onPressed: (BuildContext context) {
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
              onPressed: (BuildContext context) {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => TermsServicePage(),
                );
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
        SettingsSection(
          tiles: [
            SettingsTile(
              title: 'Log Out',
              onPressed: (BuildContext context) async {
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
