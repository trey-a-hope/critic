import 'dart:io';

import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/src/services/message_codec.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  File profilePic;
  ImageProvider profilePicImageProvider;
  UserModel currentUser;
  @override
  void initState() {
    super.initState();
  }

  Future<void> pickProfileImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      profilePicImageProvider = FileImage(image);
      profilePic = image;
    });
  }

  void save() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      bool confirm = await locator<ModalService>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you sure?');
      if (confirm) {
        try {
          locator<ModalService>()
              .showInSnackBar(scaffoldKey: scaffoldKey, message: 'Updating...');
          await submitFormData();
          await submitImages();
          locator<ModalService>()
              .showInSnackBar(scaffoldKey: scaffoldKey, message: 'Updated!');
        } on PlatformException catch (e) {
          print(e);

          locator<ModalService>()
              .showInSnackBar(scaffoldKey: scaffoldKey, message: e.message);
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
      String newPhotoUrl = await locator<StorageService>().uploadImage(
          file: profilePic, imgPath: 'Images/Users/${currentUser.uid}/Profile');
      await locator<UserService>().updateUser(
        uid: currentUser.uid,
        data: {'imgUrl': newPhotoUrl},
      );
      return;
    }
  }

  Future<void> submitFormData() async {
    await locator<UserService>().updateUser(uid: currentUser.uid, data: {
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
      body: FutureBuilder(
          future: locator<AuthService>().getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Spinner();
                break;
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error.toString()}'),
                  );
                }

                currentUser = snapshot.data;

                //Set image and username text field.
                profilePicImageProvider = NetworkImage(currentUser.imgUrl);
                usernameController.text = currentUser.username;

                return Form(
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
                );
            }
          }),
    );
  }
}
