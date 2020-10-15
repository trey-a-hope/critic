import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Event: User selects login.
class LoadPageEvent extends ProfileEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class UploadImageEvent extends ProfileEvent {
  final ImageSource imageSource;
  UploadImageEvent({@required this.imageSource});

  List<Object> get props => [imageSource];
}