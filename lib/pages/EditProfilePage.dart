import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key, @required this.currentUser})
      : super(key: key);
  final UserModel currentUser;
  @override
  State createState() => EditProfilePageState(currentUser: currentUser);
}

class EditProfilePageState extends State<EditProfilePage> {
  EditProfilePageState({@required this.currentUser});
  final UserModel currentUser;
  final GetIt getIt = GetIt.I;
  final String timeFormat = 'MMM d, yyyy @ h:mm a';
  final TextEditingController usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  @override
  void initState() {
    super.initState();

    usernameController.text = currentUser.username;
  }

  void save() async {
    if (formKey.currentState.validate()) {
      // formKey.currentState.save();

      // bool confirm = await getIt<IModalService>().showConfirmation(
      //     context: context, title: 'Submit', message: 'Are you sure?');
      // if (confirm) {
      //   try {
      //     setState(
      //       () {
      //         isLoading = true;
      //       },
      //     );

      //     //Create new user in auth.
      //     AuthResult authResult =
      //         await getIt<IAuthService>().createUserWithEmailAndPassword(
      //       email: emailController.text,
      //       password: passwordController.text,
      //     );

      //     final FirebaseUser firebaseUser = authResult.user;

      //     UserModel user = UserModel(
      //         id: '',
      //         imgUrl: DUMMY_PROFILE_PHOTO_URL,
      //         email: firebaseUser.email,
      //         created: DateTime.now(),
      //         modified: DateTime.now(),
      //         uid: firebaseUser.uid,
      //         username: usernameController.text);

      //     await getIt<IUserService>().createUser(user: user);

      //     Navigator.pop(context);
      //   } on PlatformException catch (e) {
      //     print(e);
      //     setState(
      //       () {
      //         isLoading = false;
      //       },
      //     );
      //     getIt<IModalService>().showAlert(
      //       context: context,
      //       title: 'Error',
      //       message: e.message,
      //     );
      //   }
      // }
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'),
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: save,
      ),
      body: Form(
        key: formKey,
        autovalidate: autoValidate,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: Image.network(currentUser.imgUrl).image,
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40),
              child: TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                maxLengthEnforced: true,
                decoration: InputDecoration(hintText: 'Username'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
