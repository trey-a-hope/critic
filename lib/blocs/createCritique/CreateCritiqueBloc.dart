import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
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

        yield CreateCritiqueStartState();
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      final String critiqueText = event.critique;

      try {
        DateTime now = DateTime.now();

        CritiqueModel critique = CritiqueModel(
          id: '',
          uid: _currentUser.uid,
          imdbID: movie.imdbID,
          message: critiqueText,
          modified: now,
          created: now,
          imdbRating: movie.imdbRating,
          imdbVotes: movie.imdbVotes,
          moviePlot: movie.plot,
          moviePoster: movie.poster,
          movieTitle: movie.title,
          movieYear: movie.year,
          movieDirector: movie.director,
        );

        await locator<CritiqueService>().createCritique(critique: critique);

        _createCritiqueBlocDelegate.clearText();

        _createCritiqueBlocDelegate.showMessage(
            message: 'Critique added, return to home page and refresh.');

        yield CreateCritiqueStartState();
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
            message: 'Error ${error.toString()}!');

        yield CreateCritiqueStartState();
      }
    }
  }
}
