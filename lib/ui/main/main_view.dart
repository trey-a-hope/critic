import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_view_model.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainViewModel>(
      init: MainViewModel(),
      builder: (controller) => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
