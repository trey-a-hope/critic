import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/signUp/Bloc.dart';
import 'package:critic/pages/TermsServicePage.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Bloc.dart';

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
  SignUpBloc _signUpBloc;
  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    _signUpBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (BuildContext context, SignUpState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is SignUpStartState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: state.formKey,
                  autovalidate: state.autoValidate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLengthEnforced: true,
                          // maxLength: MyFormData.nameCharLimit,
                          onFieldSubmitted: (term) {},
                          validator: locator<ValidationService>().isEmpty,
                          onSaved: (value) {},
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            hintText: 'Username',
                            // icon: Icon(Icons.email),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                        child: TextFormField(
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
                      ),
                      CheckboxListTile(
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              children: [
                                TextSpan(text: 'I accept and agree to the '),
                                TextSpan(
                                  text: 'Terms & Services',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' of Critic.')
                              ],
                            ),
                          ),
                        ),
                        value: state.termsServicesChecked,
                        onChanged: (newValue) {
                          _signUpBloc.add(
                            TermsServiceCheckboxEvent(
                                formKey: state.formKey, checked: newValue),
                          );
                        },
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('SIGN UP'),
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () {
                              if (!state.termsServicesChecked) {
                                locator<ModalService>().showInSnackBar(
                                    scaffoldKey: _scaffoldKey,
                                    message:
                                        'Error: You must check the Terms & Service first.');
                                return;
                              }

                              _signUpBloc.add(
                                SignUp(
                                  formKey: state.formKey,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  email: _emailController.text,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
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

  @override
  void navigateToTermsServicePage() {
    Route route = MaterialPageRoute(
      builder: (BuildContext context) => TermsServicePage(),
    );

    Navigator.of(context).push(route);
  }
}
