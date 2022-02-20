import 'package:critic/constants/app_themes.dart';
import 'package:critic/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'drawer_view_model.dart';

class DrawerView extends StatelessWidget {
  DrawerView({Key? key}) : super(key: key);

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

              ///TODO: Add in last after testing.
              // ListTile(
              //   leading: const Icon(Icons.menu),
              //   title: Text(
              //     'Recommendations',
              //     style: AppThemes.textTheme.headline4,
              //   ),
              //   onTap: () {
              //     Get.offNamed(Globals.ROUTES_RECOMMENDATIONS);
              //   },
              // ),
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
              ListTile(
                leading: const Icon(Icons.search),
                title: Text(
                  'Search Movies',
                  style: AppThemes.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(
                    Globals.ROUTES_SEARCH_MOVIES,
                    arguments: {
                      'returnMovie': false,
                    },
                  );
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
            ],
          ),
        ),
      ),
    );
  }
}
