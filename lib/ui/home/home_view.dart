import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/ui/critique_widget/critique_widget_view.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination_view/pagination_view.dart';
import 'home_view_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  /// Key that holds the current state of the scaffold.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        drawer: DrawerView(),
        child: Scaffold(
          appBar: TabBar(
            onTap: (index) {
              model.resetLastIDs();
            },
            controller: model.controller,
            indicatorColor: Theme.of(context).indicatorColor,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.accountMultiple,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Following',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.accountGroup,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Everyone',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: model.controller,
            children: [
              // Following
              RefreshIndicator(
                child: PaginationView<CritiqueModel>(
                  initialLoader: Center(child: CircularProgressIndicator()),
                  bottomLoader: Center(child: CircularProgressIndicator()),
                  itemBuilder: (BuildContext context, CritiqueModel critique,
                          int index) =>
                      CritiqueWidgetView(
                    critique: critique,
                  ),
                  pageFetch: (int offset) async {
                    return model.fetchFollowingCritiques(offset);
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
                          MdiIcons.movieEdit,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          '${Globals.MESSAGE_EMPTY_CRITIQUES}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  paginationViewType: PaginationViewType.listView,
                ),
                onRefresh: () async {
                  // model.resetFollowingTabLastDateTime();
                  return;
                },
              ),
              // Everyone.
              RefreshIndicator(
                child: PaginationView<CritiqueModel>(
                  initialLoader: Center(child: CircularProgressIndicator()),
                  bottomLoader: Center(child: CircularProgressIndicator()),
                  itemBuilder: (BuildContext context, CritiqueModel critique,
                          int index) =>
                      CritiqueWidgetView(
                    critique: critique,
                  ),
                  pageFetch: (int offset) async {
                    return model.fetchEveryoneCritiques(offset);
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
                          MdiIcons.movieEdit,
                          size: 100,
                          color: Colors.grey,
                        ),
                        Text(
                          '${Globals.MESSAGE_EMPTY_CRITIQUES}',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                  paginationViewType: PaginationViewType.listView,
                ),
                onRefresh: () async {
                  model.resetLastIDs();
                  return;
                },
              ),
            ],
          ),
        ),
        title: 'Home',
      ),
    );
  }
}
