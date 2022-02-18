import 'package:critic/initialize_dependencies.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/ui/drawer/drawer_view.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_critique_view_model.dart';

class CreateCritiqueView extends StatelessWidget {
  CreateCritiqueView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateCritiqueViewModel>(
      init: CreateCritiqueViewModel(),
      builder: (controller) => BasicPage(
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
            onPressed: () {
              locator<AuthService>().signOut();
            },
            child: Text('Sign Out'),
          ),
        ),
        title: 'Create Critique',
      ),
    );
  }
}
