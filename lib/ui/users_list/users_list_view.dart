import 'package:critic/models/data/user_model.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/ui/user_list_tile/loading_user_list_tile_view.dart';
import 'package:critic/ui/users_list/users_list_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:critic/ui/user_list_tile/user_list_tile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:uuid/uuid.dart';

import '../../constants/globals.dart';

class UsersListView extends StatelessWidget {
  UsersListView({Key? key}) : super(key: key);

  /// Key that holds scaffold state.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersListViewModel>(
      tag: Uuid().v4(),
      init: UsersListViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.back();
          },
        ),
        drawer: DrawerView(),
        child: PaginationView<UserModel>(
          initialLoader: ListView(
            children: [
              for (int i = 0; i < Globals.USERS_PAGE_FETCH_LIMIT; i++) ...[
                LoadingUserListTileView()
              ]
            ],
          ),
          bottomLoader: Center(child: CircularProgressIndicator()),
          itemBuilder: (BuildContext context, UserModel user, int index) {
            print(index);
            return UserListTile(user: user, returnUser: false);
          },
          pageFetch: (int offset) async {
            return model.fetchUsers(offset);
          },
          onError: (dynamic error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  'Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          onEmpty: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.account,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  '${Globals.MESSAGE_EMPTY_USERS}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          paginationViewType: PaginationViewType.listView,
        ),
        title: model.title,
      ),
    );
  }
}
