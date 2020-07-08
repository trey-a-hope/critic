import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/StorageService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';

import 'CreateCritiqueEvent.dart';
import 'CreateCritiqueState.dart';

abstract class CreateCritiqueBlocDelegate {
  void showMessage({@required String message});
  void clearText();
}

class CreateCritiqueBloc
    extends Bloc<CreateCritiqueEvent, CreateCritiqueState> {
  CreateCritiqueBloc({@required this.movie}) : super(null);
  final MovieModel movie;

  CreateCritiqueBlocDelegate _createCritiqueBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required CreateCritiqueBlocDelegate delegate}) {
    this._createCritiqueBlocDelegate = delegate;
  }

  @override
  Stream<CreateCritiqueState> mapEventToState(
      CreateCritiqueEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield CreateCritiqueStartState(
          formKey: GlobalKey<FormState>(),
          autoValidate: false,
        );
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      final GlobalKey<FormState> formKey = event.formKey;
      final String critiqueText = event.critique;

      if (formKey.currentState.validate()) {
        try {
          DateTime now = DateTime.now();

          CritiqueModel critique = CritiqueModel(
            id: '',
            userID: _currentUser.uid,
            imdbID: movie.imdbID,
            message: critiqueText,
            safe: true,
            modified: now,
            created: now,
          );

          await locator<CritiqueService>().createCritique(critique: critique);

          _createCritiqueBlocDelegate.clearText();

          _createCritiqueBlocDelegate.showMessage(message: 'Critique added!');

          yield CreateCritiqueStartState(
            formKey: formKey,
            autoValidate: false,
          );
        } catch (error) {
          _createCritiqueBlocDelegate.showMessage(
              message: 'Error ${error.toString()}!');

          yield CreateCritiqueStartState(
            formKey: formKey,
            autoValidate: true,
          );
        }
      } else {
        yield CreateCritiqueStartState(
          formKey: formKey,
          autoValidate: true,
        );
      }
    }
  }
}
