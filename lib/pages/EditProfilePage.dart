import 'dart:io';

import 'package:critic/models/UserModel.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/src/services/message_codec.dart';
// import 'package:cached_network_image/cached_network_image.dart';

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
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  File profilePic;
  ImageProvider profilePicImageProvider;
  final IModalService modalService = GetIt.I<IModalService>();
  final IStorageService storageService = GetIt.I<IStorageService>();
  final IUserService userService = GetIt.I<IUserService>();

  @override
  void initState() {
    super.initState();
    profilePicImageProvider = NetworkImage(currentUser.imgUrl);
    usernameController.text = currentUser.username;
  }

  Future<void> pickProfileImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profilePicImageProvider = FileImage(image);
      profilePic = image;
    });
  }

  void save() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      bool confirm = await modalService.showConfirmation(
          context: context, title: 'Submit', message: 'Are you sure?');
      if (confirm) {
        try {
          modalService.showInSnackBar(
              scaffoldKey: scaffoldKey, message: 'Updating...');
          await submitFormData();
          await submitImages();
          modalService.showInSnackBar(
              scaffoldKey: scaffoldKey, message: 'Updated!');
        } on PlatformException catch (e) {
          print(e);

          modalService.showInSnackBar(
              scaffoldKey: scaffoldKey, message: e.message);
        }
      }
    } else {
      setState(
        () {
          autoValidate = true;
        },
      );
    }
  }

  Future<void> submitImages() async {
    if (profilePic != null) {
      String newPhotoUrl = await storageService.uploadImage(
          file: profilePic, imgPath: 'Images/Users/${currentUser.id}/Profile');
      await userService.updateUser(
        userID: currentUser.id,
        data: {'imgUrl': newPhotoUrl},
      );
      return;
    }
  }

  Future<void> submitFormData() async {
    await userService.updateUser(userID: currentUser.id, data: {
      'username': usernameController.text,
      'modified': DateTime.now()
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40),
              child: InkWell(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: profilePicImageProvider,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                onTap: () {
                  pickProfileImage();
                },
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
