import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'edit_profile_view_model.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({Key? key}) : super(key: key);

  /// Text editing controller for user's username.
  final TextEditingController _usernameController = TextEditingController();

  /// Key that holds the form's state.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Validation service instance.
  final ValidationService _validationService = Get.find();

  /// Modal service instance.
  final ModalService _modalService = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileViewModel>(
      init: EditProfileViewModel(),
      builder: (model) {
        // Set usernameController to user name text.
        if (model.user != null) {
          _usernameController.text = model.user!.username;
        }

        return model.user == null
            ? Scaffold(body: Center(child: CircularProgressIndicator()))
            : BasicPage(
                leftIconButton: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    Get.back();
                  },
                ),
                rightIconButton: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () async {
                    /// Validate form.
                    final bool formValid = _formKey.currentState!.validate();

                    /// Return if invalid.
                    if (!formValid) return;

                    /// Ask user if they want to submit critique.
                    final bool? confirm = await _modalService.showConfirmation(
                      context: context,
                      title: 'Save Profile',
                      message: 'Are you sure?',
                    );

                    /// Return if not true.
                    if (confirm == null || !confirm) return;

                    /// Proceed to save critique.
                    bool success = await model.save(
                      username: _usernameController.text,
                    );

                    /// Show success or error message based on response.
                    if (success) {
                      Get.snackbar(
                        'Success',
                        'Your profile was updated.',
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'There was an issue saving your profile.',
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: model.user!.imgUrl,
                            imageBuilder: (context, imageProvider) => GFAvatar(
                              radius: 40,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.red,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(
                                    MdiIcons.camera,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Get.defaultDialog(
                                      title: 'Update Photo',
                                      middleText:
                                          'Take a photo with camera or choose one from gallery?',
                                      titleStyle:
                                          TextStyle(color: Colors.black),
                                      middleTextStyle:
                                          TextStyle(color: Colors.black),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            model.updateImage(
                                                imageSource:
                                                    ImageSource.camera);
                                          },
                                          child: Text('Camera'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Get.back();

                                            model.updateImage(
                                                imageSource:
                                                    ImageSource.gallery);
                                          },
                                          child: Text('Gallery'),
                                        )
                                      ],
                                      barrierDismissible: true,
                                      radius: 10,
                                      // ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(40),
                        child: TextFormField(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline6!.color),
                          cursorColor:
                              Theme.of(context).textTheme.headline5!.color,
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          validator: _validationService.isEmpty,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .color),
                            hintText: 'Username',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .color),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                title: 'Edit Profile',
              );
      },
    );
  }

  // showSelectImageDialog() {
  //   return Platform.isIOS ? iOSBottomSheet() : androidDialog();
  // }
  //
  // iOSBottomSheet() {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext buildContext) {
  //         return CupertinoActionSheet(
  //           title: Text('Add Photo'),
  //           actions: <Widget>[
  //             CupertinoActionSheetAction(
  //               child: Text('Take Photo'),
  //               onPressed: () {
  //                 Navigator.pop(buildContext);
  //                 context.read<ProfileBloc>().add(
  //                       UploadImageEvent(imageSource: ImageSource.camera),
  //                     );
  //               },
  //             ),
  //             CupertinoActionSheetAction(
  //               child: Text('Choose From Gallery'),
  //               onPressed: () {
  //                 Navigator.pop(buildContext);
  //                 context.read<ProfileBloc>().add(
  //                       UploadImageEvent(imageSource: ImageSource.gallery),
  //                     );
  //               },
  //             )
  //           ],
  //           cancelButton: CupertinoActionSheetAction(
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(color: Colors.redAccent),
  //             ),
  //             onPressed: () => Navigator.pop(buildContext),
  //           ),
  //         );
  //       });
  // }
  //
  // androidDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         title: Text('Add Photo'),
  //         children: <Widget>[
  //           SimpleDialogOption(
  //             child: Text('Take Photo'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               context.read<ProfileBloc>().add(
  //                     UploadImageEvent(imageSource: ImageSource.camera),
  //                   );
  //             },
  //           ),
  //           SimpleDialogOption(
  //             child: Text('Choose From Gallery'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               context.read<ProfileBloc>().add(
  //                     UploadImageEvent(imageSource: ImageSource.gallery),
  //                   );
  //             },
  //           ),
  //           SimpleDialogOption(
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(color: Colors.redAccent),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
