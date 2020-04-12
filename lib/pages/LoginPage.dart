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
  final GetIt getIt = GetIt.I;

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
        var authResult = await getIt<IAuthService>().signInWithEmailAndPassword(
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
            getIt<IModalService>().showAlert(
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
                          validator: getIt<IValidationService>().email,
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
                          validator: getIt<IValidationService>().password,
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
                            // child: Text(
                            //   "New to Critic?",
                            //   textAlign: TextAlign.right,
                            //   style: TextStyle(
                            //     color: Color.fromARGB(255, 232, 63, 63),
                            //     fontFamily: "Avenir",
                            //     fontWeight: FontWeight.w800,
                            //     fontSize: 16,
                            //   ),
                            // ),
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

    // return Scaffold(
    //   body: SingleChildScrollView(
    //     child: Container(
    //         width: screenWidth,
    //         height: screenHeight,
    //         child: Padding(
    //           padding: SCAFFOLD_PADDING,
    //           child: isLoading
    //               ? Spinner(text: 'Logging In...')
    //               : Form(
    //                   key: formKey,
    //                   autovalidate: autoValidate,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       SilentNavbar(
    //                         title: 'Login',
    //                         leftTap: () => {Navigator.of(context).pop()},
    //                       ),
    //                       Container(
    //                         margin:
    //                             EdgeInsets.only(top: 60, left: 10, right: 10),
    //                         child: TextFormField(
    //                           controller: emailController,
    //                           keyboardType: TextInputType.emailAddress,
    //                           textInputAction: TextInputAction.next,
    //                           maxLengthEnforced: true,
    //                           // maxLength: MyFormData.nameCharLimit,
    //                           onFieldSubmitted: (term) {},
    //                           validator: getIt<IValidatorService>().email,
    //                           onSaved: (value) {},
    //                           decoration: InputDecoration(
    //                             focusedBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(color: Colors.red),
    //                             ),
    //                             hintText: 'Email',
    //                             // icon: Icon(Icons.email),
    //                             fillColor: Colors.white,
    //                           ),
    //                         ),
    //                       ),
    //                       Container(
    //                         margin:
    //                             EdgeInsets.only(top: 30, left: 10, right: 10),
    //                         child: TextFormField(
    //                           controller: passwordController,
    //                           keyboardType: TextInputType.emailAddress,
    //                           textInputAction: TextInputAction.next,
    //                           maxLengthEnforced: true,
    //                           // maxLength: MyFormData.nameCharLimit,
    //                           onFieldSubmitted: (term) {},
    //                           obscureText: true,
    //                           validator: getIt<IValidatorService>().password,
    //                           onSaved: (value) {},
    //                           decoration: InputDecoration(
    //                             focusedBorder: UnderlineInputBorder(
    //                               borderSide: BorderSide(color: Colors.red),
    //                             ),
    //                             hintText: 'Password',
    //                             // icon: Icon(Icons.email),
    //                             fillColor: Colors.white,
    //                           ),
    //                         ),
    //                       ),
    //                       Spacer(),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: <Widget>[
    //                           SilentButton(
    //                             title: 'CONTINUE',
    //                             onTap: login,
    //                           )
    //                         ],
    //                       ),
    //                       Align(
    //                         alignment: Alignment.topCenter,
    //                         child: Container(
    //                           margin: EdgeInsets.only(top: 30),
    //                           child: InkWell(
    //                             child: Text(
    //                               "Forgot Password?",
    //                               textAlign: TextAlign.right,
    //                               style: TextStyle(
    //                                 color: Color.fromARGB(255, 232, 63, 63),
    //                                 fontFamily: "Avenir",
    //                                 fontWeight: FontWeight.w800,
    //                                 fontSize: 16,
    //                               ),
    //                             ),
    //                             onTap: () => {
    //                               Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                   builder: (context) =>
    //                                       ForgotPasswordPage(),
    //                                 ),
    //                               )
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //         )),
    //   ),
    // );
  }
}
