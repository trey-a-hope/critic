import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  LoginBloc loginBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.close();
  }

  Widget buildFormView({
    @required double screenHeight,
    @required double screenWidth,
    @required LoginBloc loginBloc,
    @required bool autovalidate,
  }) {
    return SafeArea(
      child: Container(
        height: screenHeight,
        width: screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  autovalidate: autovalidate,
                  controller: emailController,
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
                  autovalidate: autovalidate,

                  controller: passwordController,
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
                    loginBloc.add(
                      Login(
                          email: emailController.text,
                          password: passwordController.text),
                    );
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //Assign LoginBloc
    loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        //"Do stuff" on state changes.
        listener: (BuildContext context, LoginState state) {
          //Navigation actions would go here....

          //If user fails login, display error in snack bar.
          if (state is LoginFailed) {
            locator<ModalService>().showInSnackBar(
                scaffoldKey: scaffoldKey,
                message: 'Error: ${state.error.message}');
          }
        },
        //Change view on state changes.
        builder: (BuildContext context, LoginState state) {
          if (state is LoginNotStarted) {
            return buildFormView(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              loginBloc: loginBloc,
              autovalidate: false,
            );
          } else if (state is LoggingIn) {
            return Spinner();
          } else if (state is LoginSuccessful) {
            return Center(
              child: Text(state.authResult.user.uid),
            );
          } else if (state is LoginFailed) {
            return buildFormView(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              loginBloc: loginBloc,
              autovalidate: true,
            );
          }
          return Center(
            child: Text('You should NEVER see this.'),
          );
        },
      ),
    );
  }
}
