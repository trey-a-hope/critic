import 'package:critic/constants/globals.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/ui/settings/settings_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:launch_review/launch_review.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  /// Instantiate modal service.
  final ModalService _modalService = Get.find();

  /// Instantiate auth service.
  final AuthService _authService = Get.find();

  /// Get storage instance.
  final GetStorage _getStorage = Get.find();

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
                'Personal'.toUpperCase(),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ListTile(
              title: Text(
                '${_getStorage.read(Globals.DARK_MODE_ENABLED) ?? false ? 'Dark' : 'Light'} Mode Enabled',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: DayNightSwitcher(
                isDarkModeEnabled:
                    _getStorage.read(Globals.DARK_MODE_ENABLED) ?? false,
                onStateChanged: (isDarkModeEnabled) async {
                  // Save user's selection of dark mode.
                  await _getStorage.write(
                      Globals.DARK_MODE_ENABLED, isDarkModeEnabled);

                  // Update the theme from dark/light.
                  Get.changeThemeMode(
                      isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light);
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
                Get.toNamed(Globals.ROUTES_CONTACT);
              },
            ),
            ListTile(
              title: Text(
                'Leave a Review',
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
              onTap: () {
                LaunchReview.launch(
                    androidAppId: 'com.io.critic', iOSAppId: '1508043723');
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
                  // Clear user identifier for crashlytics.
                  await FirebaseCrashlytics.instance.setUserIdentifier('');

                  // Sign user out of auth.
                  await _authService.signOut();
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
