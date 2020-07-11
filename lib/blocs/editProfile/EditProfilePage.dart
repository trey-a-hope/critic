import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/editProfile/Bloc.dart';
import 'package:critic/services/ModalService.dart';
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
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (BuildContext context, EditProfileState state) {
          if (state is LoadingState) {
            return Spinner();
          }

          if (state is EditProfileStartState) {
            _usernameController.text = state.currentUser.username;

            return SafeArea(
              child: Form(
                key: state.formKey,
                autovalidate: state.autoValidate,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: InkWell(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: state.profilePicImageProvider,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        onTap: () {
                          _editProfileBloc.add(
                            PickProfileImageEvent(),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(hintText: 'Username'),
                      ),
                    ),
                    Spacer(),
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        _editProfileBloc.add(
                          SaveFormEvent(
                              username: _usernameController.text,
                              formKey: state.formKey),
                        );
                      },
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
    locator<ModalService>()
        .showInSnackBar(scaffoldKey: _scaffoldKey, message: message);
  }
}
