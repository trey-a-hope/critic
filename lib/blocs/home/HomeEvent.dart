import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//Event: User selects login.
class LoadPageEvent extends HomeEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class RequestNextPageEvent extends HomeEvent {
  RequestNextPageEvent();

  List<Object> get props => [];
}


class AddCritiqueEvent extends HomeEvent {
  AddCritiqueEvent();

  List<Object> get props => [];
}
