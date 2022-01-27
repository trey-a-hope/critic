part of 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
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
            // color: colorGrey,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    colorGrey.withOpacity(0.7),
                    colorGrey.withOpacity(0.9)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1]),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: width,
                  width: width,
                  child: Center(
                    child: Image.asset(
                      ASSET_APP_ICON_LIGHT,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoadingState) {
                          return Spinner();
                        }

                        if (state is LoginErrorState) {
                          final String errorMessage = state.error.message ??
                              'Could not log in at this time.';

                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    '$errorMessage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Try Again?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<LoginBloc>().add(
                                          TryAgain(),
                                        );
                                  },
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is LoginInitialState) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
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
                                  'The best place for movie & tv show reviews.',
                                  style: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Spacer(),
                                FullWidthButton(
                                  icon: Icon(MdiIcons.google),
                                  buttonColor: Colors.white,
                                  text: 'Sign in with Google',
                                  textColor: Colors.blue,
                                  onPressed: () async {
                                    context.read<LoginBloc>().add(
                                          GoogleSignInEvent(),
                                        );
                                  },
                                ),
                                if (Platform.isIOS) ...[
                                  SizedBox(height: 10),
                                  FullWidthButton(
                                    icon: Icon(MdiIcons.apple),
                                    buttonColor: Colors.white,
                                    text: 'Sign in with Apple',
                                    textColor: Colors.red,
                                    onPressed: () async {
                                      context.read<LoginBloc>().add(
                                            AppleSignInEvent(),
                                          );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        }

                        return Container();
                      },
                      listener: (context, state) {}),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
