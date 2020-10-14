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
  final String critique;

  SubmitEvent({
    @required this.critique,
  });

  List<Object> get props => [
        critique,
      ];
}
