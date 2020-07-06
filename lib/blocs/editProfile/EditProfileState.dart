import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends EditProfileState {}

class EditProfileStartState extends EditProfileState {
  final UserModel currentUser;
  final bool autoValidate;
  final GlobalKey<FormState> formKey;
  final ImageProvider profilePicImageProvider;

  EditProfileStartState(
      {@required this.currentUser,
      @required this.autoValidate,
      @required this.formKey,
      @required this.profilePicImageProvider});

  @override
  List<Object> get props => [
        currentUser,
        autoValidate,
        formKey,
        profilePicImageProvider,
      ];
}

class ErrorState extends EditProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
