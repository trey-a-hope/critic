part of 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Box<String> loginCredentialsBox =
        Hive.box<String>(HIVE_BOX_LOGIN_CREDENTIALS);

    //Set form values if present.
    if (loginCredentialsBox.get('email') != null) {
      String email = loginCredentialsBox.get('email')!;
      String password = loginCredentialsBox.get('password')!;

      _emailController.text = email;
      _passwordController.text = password;
    }

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
            child: Form(
              key: _formKey,
              child: ListView(
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
                  BlocConsumer<LoginBloc, LoginState>(
                      builder: (context, state) {
                    if (state is LoginLoading) {
                      return Spinner();
                    }

                    if (state is LoginError) {
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
                                    borderRadius: BorderRadius.circular(8.0),
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

                    if (state is LoginInitial) {
                      bool passwordVisible = state.passwordVisible;
                      bool rememberMe = state.rememberMe;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: locator<ValidationService>().email,
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
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
                              obscureText: !passwordVisible,
                              controller: _passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(UpdatePasswordVisibleEvent());
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(90.0),
                                    ),
                                    borderSide: BorderSide.none,
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
                            Container(
                              color: Colors.white,
                              height: 50,
                              width: double.infinity,
                              child: CheckboxListTile(
                                title: Text(
                                  'Remember Me',
                                ),
                                value: rememberMe,
                                onChanged: (newValue) {
                                  context.read<LoginBloc>().add(
                                        UpdateRememberMeEvent(),
                                      );
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
                                if (!_formKey.currentState!.validate()) return;

                                final String email = _emailController.text;
                                final String password =
                                    _passwordController.text;

                                context.read<LoginBloc>().add(
                                      Login(
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
                            ),
                            Center(
                              child: InkWell(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.grey.shade100,
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
                          ],
                        ),
                      );
                    }

                    return Container();
                  }, listener: (context, state) {
                    if (state == LoginSuccess()) {
                      //Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                    if (state is LoginError) {
                      print('failure');
                      //todo: Report this sign in failure somewhere perhaps?
                    }
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
