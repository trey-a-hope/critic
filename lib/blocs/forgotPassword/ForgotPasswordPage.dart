import 'package:critic/services/modal_service.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage>
    implements ForgotPasswordDelegate {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordBloc _forgotPasswordBloc;

  @override
  void initState() {
    _forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    _forgotPasswordBloc.setDelegate(delegate: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (BuildContext context, ForgotPasswordState state) {
        if (state is LoadingState) {
          return Container(
            color: Colors.white,
            child: Spinner(),
          );
        }

        if (state is LoadedState) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Forgot Password'),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                width: screenWidth,
                height: screenHeight,
                color: Colors.white,
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                            'Confirm your email and we\'ll send the instructions.'),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            cursorColor: Colors.black,
                            validator: locator<ValidationService>().email,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            controller: _emailController,
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'SFUIDisplay'),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color),
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              labelStyle: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      FullWidthButton(
                        buttonColor: Colors.red,
                        text: 'Reset Password',
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) return;

                          final bool confirm =
                              await locator<ModalService>().showConfirmation(
                            context: context,
                            title: 'Send instructions to this email.',
                            message: 'Are you sure?',
                          );

                          if (!confirm) return;

                          _forgotPasswordBloc.add(
                            SubmitEvent(
                              email: _emailController.text,
                            ),
                          );
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is ErrorState) {
          return Container(
            child: Center(
              child: Text(
                state.error.toString(),
              ),
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }
}
