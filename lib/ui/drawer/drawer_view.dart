import 'package:critic/constants/app_themes.dart';
import 'package:critic/constants/globals.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawer_view_model.dart';

class DrawerView extends StatelessWidget {
  DrawerView({Key? key}) : super(key: key);

  /// Instantiate modal service.
  final ModalService _modalService = Get.find();

  /// Instantiate auth service.
  final AuthService _authService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawerViewModel>(
      init: DrawerViewModel(),
      builder: (model) => Drawer(
          child: SafeArea(
        child: Column(
          children: [
            model.user == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Hello, ${model.user!.username}',
                            style: AppThemes.textTheme.headline4,
                          ),
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            model.user!.imgUrl,
                          ),
                        ),
                      ],
                    ),
                  ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'Home',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_HOME);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(
                'Create Critique',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_CREATE_CRITIQUE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Profile',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_PROFILE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu),
              title: Text(
                'Recommendations',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_RECOMMENDATIONS);
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: Text(
                'Watch List',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_WATCH_LIST);
              },
            ),
            Spacer(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'Settings',
                style: AppThemes.textTheme.headline4,
              ),
              onTap: () {
                Get.offNamed(Globals.ROUTES_SETTINGS);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Logout',
                style: AppThemes.textTheme.headline4,
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
      )),
    );
  }
}
