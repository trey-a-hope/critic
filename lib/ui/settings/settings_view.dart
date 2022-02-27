import 'package:critic/constants/globals.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/ui/settings/settings_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  /// Instantiate modal service.
  final ModalService _modalService = Get.find();

  /// Instantiate auth service.
  final AuthService _authService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsViewModel>(
      init: SettingsViewModel(),
      builder: (model) => BasicPage(
        leftIconButton: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        drawer: DrawerView(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Get.toNamed(Globals.ROUTES_CONTACT);
              },
            ),
            // ListTile(
            //   title: Text(
            //     'Leave a Suggestion',
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   trailing: Icon(
            //     Icons.chevron_right,
            //     color: Theme.of(context).iconTheme.color,
            //   ),
            //   onTap: () {
            //     //TODO: Go to suggestions page.
            //   },
            // ),
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
                Get.toNamed(Globals.ROUTES_TERMS_OF_SERVICE);
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.logout,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () async {
                /// Ask user if they're sure about log out.
                bool? confirm = await _modalService.showConfirmation(
                  context: context,
                  title: 'Logout',
                  message: 'Are you sure?',
                );
                if (confirm == null || confirm) {
                  await _authService.signOut();
                  print('Goodbye...');
                }
              },
            ),
          ],
        ),
        title: 'Settings',
      ),
    );
  }
}
