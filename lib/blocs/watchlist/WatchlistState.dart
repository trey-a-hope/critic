import 'package:critic/models/UserModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WatchlistState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends WatchlistState {}

class LoadedState extends WatchlistState {
  LoadedState();

  @override
  List<Object> get props => [];
}
