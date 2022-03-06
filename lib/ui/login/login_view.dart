import 'dart:io';
import 'package:critic/constants/globals.dart';
import 'package:critic/widgets/full_width_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'login_view_model.dart';
import 'package:new_version/new_version.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginViewModel>(
      init: LoginViewModel(),
      builder: (model) {
        // Show new version alert message if necessary.
        NewVersion().showAlertIfNecessary(context: context);

        return Scaffold(
          body: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Globals.ASSET_LOGIN_BG),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                // color: colorGrey,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 1],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Image.asset(
                          Globals.ASSET_APP_ICON_LIGHT,
                          height: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text(
                              'Welcome to Critic',
                              style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              Globals.SPLASH_MESSAGE,
                              style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            FullWidthButton(
                              icon: const Icon(MdiIcons.google),
                              buttonColor: Colors.white,
                              text: 'Sign in with Google',
                              textColor: Colors.blue,
                              onPressed: () async {
                                model.googleSignIn();
                              },
                            ),
                            if (Platform.isIOS) ...[
                              const SizedBox(height: 10),
                              FullWidthButton(
                                icon: const Icon(MdiIcons.apple),
                                buttonColor: Colors.white,
                                text: 'Sign in with Apple',
                                textColor: Colors.red,
                                onPressed: () async {
                                  model.appleSignIn();
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
