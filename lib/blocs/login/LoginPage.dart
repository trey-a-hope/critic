import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/Bloc.dart' as SIGN_UP_BP;
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart' as LOGIN_BP;

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: BlocBuilder<LOGIN_BP.LoginBloc, LOGIN_BP.LoginState>(
        builder: (BuildContext context, LOGIN_BP.LoginState state) {
          if (state is LOGIN_BP.LoadingState) {
            return Spinner();
          }

          if (state is LOGIN_BP.LoginStartState) {
            return SafeArea(
              child: Container(
                height: screenHeight,
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: state.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          autovalidate: state.autoValidate,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          maxLengthEnforced: true,
                          // maxLength: MyFormData.nameCharLimit,
                          onFieldSubmitted: (term) {},
                          validator: locator<ValidationService>().email,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            hintText: 'Email',
                            // icon: Icon(Icons.email),
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidate: state.autoValidate,

                          controller: _passwordController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          maxLengthEnforced: true,
                          // maxLength: MyFormData.nameCharLimit,
                          onFieldSubmitted: (term) {},
                          obscureText: true,
                          validator: locator<ValidationService>().password,
                          // onSaved: (value) {},
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            hintText: 'Password',
                            // icon: Icon(Icons.email),
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        OutlineButton(
                          child: Text('Login'),
                          onPressed: () {
                            _loginBloc.add(
                              LOGIN_BP.Login(
                                email: _emailController.text,
                                password: _passwordController.text,
                                formKey: state.formKey,
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        OutlineButton(
                          child: Text('Sign Up'),
                          onPressed: () {
                            Route route = MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => SIGN_UP_BP.SignUpBloc(),
                                child: SIGN_UP_BP.SignUpPage(),
                              ),
                            );

                            Navigator.push(context, route);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
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
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
