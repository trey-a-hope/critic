import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Event: User selects login.
class LoadPageEvent extends EditProfileEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class SaveFormEvent extends EditProfileEvent {
  final GlobalKey<FormState> formKey;
  final String username;

  SaveFormEvent({
    @required this.formKey,
    @required this.username,
  });

  List<Object> get props => [
        formKey,
      ];
}

class UploadPictureEvent extends EditProfileEvent {
  final File image;

  UploadPictureEvent({
    @required this.image,
  });

  List<Object> get props => [
        image,
      ];
}
