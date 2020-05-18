import 'package:critic/ServiceLocator.dart';
import 'package:critic/pages/SignUpPage.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/GoodButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController =
      TextEditingController(text: 'trey.a.hope@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'Peachy33');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      try {
        setState(
          () {
            isLoading = true;
          },
        );
        var authResult = await locator<AuthService>().signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (authResult.user == null) {
          print('User not found.');
        } else {
          print('Welcome back ${authResult.user.email}');
        }
      } catch (e) {
        setState(
          () {
            isLoading = false;
            locator<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: e.message,
            );
          },
        );
      }
    } else {
      setState(
        () {
          autoValidate = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: isLoading
          ? Spinner()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: formKey,
                  autovalidate: autoValidate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
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
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GoodButton(
                            title: 'CONTINUE',
                            onTap: login,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          child: InkWell(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'New to Critic?',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 232, 63, 63),
                                      fontFamily: "Avenir",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Sign Up',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 232, 63, 63),
                                      fontFamily: "Avenir",
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );

  }
}
