import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/Bloc.dart' as SIGN_UP_BP;
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart' as LOGIN_BP;
import 'package:critic/blocs/forgotPassword/Bloc.dart' as FORGOT_PASSWORD_BP;

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin
    implements LOGIN_BP.LoginBlocDelegate {
  LOGIN_BP.LoginBloc _loginBloc;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LOGIN_BP.LoginBloc>(context);
    _loginBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<LOGIN_BP.LoginBloc, LOGIN_BP.LoginState>(
        builder: (BuildContext context, LOGIN_BP.LoginState state) {
          if (state is LOGIN_BP.LoadingState) {
            return Spinner();
          }

          if (state is LOGIN_BP.LoginStartState) {
            return Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ASSET_LOGIN_BG),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.7)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 1]),
                  ),
                ),
                SafeArea(
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100,
                            ),
                            Image.asset(
                              ASSET_APP_ICON,
                              height: 100,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: locator<ValidationService>().email,
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.alternate_email,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(90.0),
                                    ),
                                    borderSide: BorderSide.none,

                                    //borderSide: const BorderSide(),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "WorkSansLight"),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  hintText: 'Email'),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: locator<ValidationService>().password,
                              obscureText: true,
                              controller: _passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(90.0),
                                    ),
                                    borderSide: BorderSide.none,

                                    //borderSide: const BorderSide(),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "WorkSansLight"),
                                  filled: true,
                                  fillColor: Colors.white24,
                                  hintText: 'Password'),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: InkWell(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      create: (BuildContext context) =>
                                          FORGOT_PASSWORD_BP
                                              .ForgotPasswordBloc()
                                            ..add(
                                              FORGOT_PASSWORD_BP
                                                  .LoadPageEvent(),
                                            ),
                                      child: FORGOT_PASSWORD_BP
                                          .ForgotPasswordPage(),
                                    ),
                                  );
                                  Navigator.push(context, route);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            FullWidthButton(
                              buttonColor: Colors.red,
                              text: 'Login',
                              textColor: Colors.white,
                              onPressed: () async {
                                if (!_formKey.currentState.validate()) return;

                                final String email = _emailController.text;
                                final String password =
                                    _passwordController.text;

                                _loginBloc.add(
                                  LOGIN_BP.Login(
                                    email: email,
                                    password: password,
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      create: (BuildContext context) =>
                                          SIGN_UP_BP.SignUpBloc(),
                                      child: SIGN_UP_BP.SignUpPage(),
                                    ),
                                  );
                                  Navigator.push(context, route);
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: 'New to Critic?',
                                          style: TextStyle(color: Colors.grey)),
                                      TextSpan(text: ' Create an Account')
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }

          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }

  @override
  void navigateHome() {
    Navigator.of(context).pop();
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
