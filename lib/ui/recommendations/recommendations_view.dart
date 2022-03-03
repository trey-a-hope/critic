import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/ui/recommendations/recommendations_view_model.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendationsView extends StatelessWidget {
  RecommendationsView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecommendationsViewModel>(
      init: RecommendationsViewModel(),
      builder: (model) => BasicPage(
        scaffoldKey: _scaffoldKey,
        leftIconButton: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        drawer: DrawerView(),
        child: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Sign Out'),
          ),
        ),
        title: 'Recommendations',
      ),
    );
  }
}
