part of 'sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin
    implements SignUpBlocDelegate {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<SignUpBloc>().setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (BuildContext context, SignUpState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is SignUpStartState) {
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
                              obscureText: true,
                              controller: _passwordController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
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
                            SizedBox(height: 20),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: locator<ValidationService>().isEmpty,
                              controller: _usernameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
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
                                  hintText: 'Username'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: Colors.white,
                              height: 50,
                              width: double.infinity,
                              child: CheckboxListTile(
                                checkColor: Colors.white,
                                title: InkWell(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TermsServicePage(),
                                    );
                                    Navigator.of(context).push(route);
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      children: [
                                        TextSpan(
                                            text: 'I accept and agree to the '),
                                        TextSpan(
                                          text: 'Terms & Services',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(text: ' of Critic.')
                                      ],
                                    ),
                                  ),
                                ),
                                value: state.termsServicesChecked,
                                onChanged: (newValue) {
                                  context.read<SignUpBloc>().add(
                                        TermsServiceCheckboxEvent(
                                            checked: newValue!),
                                      );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            FullWidthButton(
                              buttonColor: Colors.red,
                              text: 'Sign Up',
                              textColor: Colors.white,
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;

                                final bool? confirm =
                                    await locator<ModalService>()
                                        .showConfirmation(
                                            context: context,
                                            title: 'Login',
                                            message: 'Are you sure?');

                                if (confirm == null || !confirm) return;

                                context.read<SignUpBloc>().add(
                                      SignUp(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        username: _usernameController.text,
                                      ),
                                    );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: 'Already have an account?',
                                          style: TextStyle(color: Colors.grey)),
                                      TextSpan(text: ' Log in.')
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
  void showMessage({required String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void navigateToTermsServicePage() {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => TermsServicePage(),
    );

    Navigator.of(context).push(route);
  }
}
