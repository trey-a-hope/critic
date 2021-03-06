import 'package:critic/constants/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'drawer_view_model.dart';

class DrawerView extends StatelessWidget {
  DrawerView({Key? key}) : super(key: key);

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawerViewModel>(
      init: DrawerViewModel(),
      builder: (model) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        model.user == null
                            ? 'Hello...'
                            : 'Hello, ${model.user!.username}',
                        style: context.textTheme.headline4,
                      ),
                    ),
                    model.user == null
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  NetworkImage(Globals.DUMMY_PROFILE_PHOTO_URL),
                            ),
                          )
                        : CircleAvatar(
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
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.offNamed(Globals.ROUTES_HOME);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: Text(
                  'Create Critique',
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(Globals.ROUTES_CREATE_CRITIQUE);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  'Profile',
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(
                    Globals.ROUTES_PROFILE,
                    arguments: {
                      'uid': model.user!.uid,
                    },
                  );
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
                leading: const Icon(Icons.remove_red_eye_rounded),
                title: Text(
                  'Watch List',
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(Globals.ROUTES_WATCH_LIST);
                },
              ),
              ListTile(
                leading: const Icon(MdiIcons.movieOpenStar),
                title: Text(
                  'Search Movies',
                  style: context.textTheme.headline4,
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
              ListTile(
                leading: const Icon(MdiIcons.accountMultiple),
                title: Text(
                  'Search Users',
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(
                    Globals.ROUTES_SEARCH_USERS,
                    arguments: {
                      'returnUser': false,
                    },
                  );
                },
              ),
              Spacer(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(
                  'Settings',
                  style: context.textTheme.headline4,
                ),
                onTap: () {
                  Get.toNamed(Globals.ROUTES_SETTINGS);
                },
              ),
              Text(
                'Version ${_getStorage.read(Globals.APP_VERSION)}',
              )
            ],
          ),
        ),
      ),
    );
  }
}
