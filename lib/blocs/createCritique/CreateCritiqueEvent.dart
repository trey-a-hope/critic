import 'package:critic/blocs/editProfile/Bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateCritiqueEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CreateCritiqueEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class SubmitEvent extends CreateCritiqueEvent {
  final GlobalKey<FormState> formKey;
  final String critique;

  SubmitEvent({
    @required this.formKey,
    @required this.critique,
  });

  List<Object> get props => [
        formKey,
        critique,
      ];
}
