import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DemoState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends DemoState {}

class LoadedState extends DemoState {
  LoadedState();

  @override
  List<Object> get props => [];
}
