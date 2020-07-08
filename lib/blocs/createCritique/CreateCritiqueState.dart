import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateCritiqueState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CreateCritiqueState {}

class CreateCritiqueStartState extends CreateCritiqueState {
  final bool autoValidate;
  final GlobalKey<FormState> formKey;

  CreateCritiqueStartState({
    @required this.autoValidate,
    @required this.formKey,
  });

  @override
  List<Object> get props => [
        autoValidate,
        formKey,
      ];
}
