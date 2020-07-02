import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  SearchMoviesBloc();

  @override
  SearchMoviesState get initialState => SearchMoviesState();

  UserModel _currentUser;

  @override
  Stream<SearchMoviesState> mapEventToState(SearchMoviesEvent event) async* {
    // if (event is LoadPageEvent) {
    //   yield LoadingState();

    //   _currentUser = await locator<AuthService>().getCurrentUser();

    //   yield LoadedState(currentUser: _currentUser);
    // }
  }
}
