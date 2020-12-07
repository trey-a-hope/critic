import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
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

  bool watchListHasMovie = false;

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

        watchListHasMovie = await locator<UserService>().watchListHasMovie(
          uid: _currentUser.uid,
          imdbID: movie.imdbID,
        );

        yield CreateCritiqueStartState(
          movie: movie,
          watchListHasMovie: watchListHasMovie,
        );
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is AddMovieToWatchlistEvent) {
      try {
        await locator<UserService>()
            .addMovieToWatchList(uid: _currentUser.uid, movie: movie);

        watchListHasMovie = true;

        yield CreateCritiqueStartState(
          movie: movie,
          watchListHasMovie: watchListHasMovie,
        );
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
          message: error.toString(),
        );
      }
    }

    if (event is RemoveMovieFromWatchlistEvent) {
      try {
        await locator<UserService>().removeMovieFromWatchList(
          uid: _currentUser.uid,
          imdbID: movie.imdbID,
        );

        watchListHasMovie = false;

        yield CreateCritiqueStartState(
          movie: movie,
          watchListHasMovie: watchListHasMovie,
        );
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
          message: error.toString(),
        );
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
          movieYear: movie.released,
          movieDirector: movie.director,
          likeCount: 0,
        );

        await locator<CritiqueService>().createCritique(critique: critique);

        _createCritiqueBlocDelegate.clearText();

        _createCritiqueBlocDelegate.showMessage(
            message: 'Critique added, check it out on the home page.');

        yield CreateCritiqueStartState(
          movie: movie,
          watchListHasMovie: watchListHasMovie,
        );
      } catch (error) {
        _createCritiqueBlocDelegate.showMessage(
            message: 'Error ${error.toString()}!');

        yield CreateCritiqueStartState(
          movie: movie,
          watchListHasMovie: watchListHasMovie,
        );
      }
    }
  }
}
