import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/editProfile/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    implements EditProfileBlocDelegate {
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditProfileBloc _editProfileBloc;

  @override
  void initState() {
    _editProfileBloc = BlocProvider.of<EditProfileBloc>(context);
    _editProfileBloc.setDelegate(delegate: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorNavy,
      ),
      body: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (BuildContext context, EditProfileState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is EditProfileStartState) {
            return SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        validator: locator<ValidationService>().isEmpty,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        decoration: InputDecoration(hintText: 'Username'),
                      ),
                    ),
                    Spacer(),
                    FullWidthButton(
                      buttonColor: Colors.red,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        bool confirm = await locator<ModalService>()
                            .showConfirmation(
                                context: context,
                                title: 'Submit',
                                message: 'Are you sure?');

                        if (!confirm) return;

                        _editProfileBloc.add(
                          SaveFormEvent(
                            username: _usernameController.text,
                          ),
                        );
                      },
                      text: 'Submit',
                    )
                  ],
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  void showMessage({String message}) {
    locator<ModalService>().showInSnackBar(context: context, message: message);
  }

  @override
  void setTextFields({@required UserModel user}) {
    _usernameController.text = user.username;
  }
}
