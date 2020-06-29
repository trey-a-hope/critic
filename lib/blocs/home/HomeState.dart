//import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

//State: View of the user when loogging in.
class LoadingState extends HomeState {}

//State: View of a successful login.
class LoadedState extends HomeState {
  final List<DocumentSnapshot> docs;
  LoadedState({
    @required this.docs,
  });

  @override
  List<Object> get props => [docs,];
}

//State: View of an unsuccessful login.
class ErrorState extends HomeState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
