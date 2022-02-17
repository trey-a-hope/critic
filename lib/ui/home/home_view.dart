import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (controller) => BasicPage(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                locator<AuthService>().signOut();
              },
              child: Text('Sign Out'),
            ),
          ),
          title: 'Home'),
    );
  }
}
