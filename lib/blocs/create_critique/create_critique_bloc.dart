import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/critique_model.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/small_critique_view.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/Constants.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

part 'create_critique_event.dart';
part 'create_critique_state.dart';
part 'create_critique_page.dart';

abstract class CreateCritiqueBlocDelegate {
  void showMessage({required String message});
  void clearText();
}

class CreateCritiqueBloc
    extends Bloc<CreateCritiqueEvent, CreateCritiqueState> {
  MovieModel? movie;

  CreateCritiqueBloc({required this.movie}) : super(InitialState()) {
    movie = null;
  }

  CreateCritiqueBlocDelegate? _createCritiqueBlocDelegate;
  late UserModel _currentUser;

  bool watchListHasMovie = false;

  List<CritiqueModel> _otherCritiques = [];

  void setDelegate({required CreateCritiqueBlocDelegate delegate}) {
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
          uid: _currentUser.uid!,
          imdbID: movie!.imdbID,
        );

        _otherCritiques = await locator<CritiqueService>().listSimilar(
          id: null,
          imdbID: movie!.imdbID,
        );

        yield LoadedState(
          movie: movie!,
          watchListHasMovie: watchListHasMovie,
          currentUser: _currentUser,
          otherCritiques: _otherCritiques,
        );
      } catch (error) {
        _createCritiqueBlocDelegate!
            .showMessage(message: 'Error: ${error.toString()}');
      }
    }

    if (event is AddMovieToWatchlistEvent) {
      try {
        await locator<UserService>()
            .addMovieToWatchList(uid: _currentUser.uid!, movie: movie!);

        watchListHasMovie = true;

        yield LoadedState(
          movie: movie!,
          watchListHasMovie: watchListHasMovie,
          currentUser: _currentUser,
          otherCritiques: _otherCritiques,
        );
      } catch (error) {
        _createCritiqueBlocDelegate!.showMessage(
          message: error.toString(),
        );
      }
    }

    if (event is RemoveMovieFromWatchlistEvent) {
      try {
        await locator<UserService>().removeMovieFromWatchList(
          uid: _currentUser.uid!,
          imdbID: movie!.imdbID,
        );

        watchListHasMovie = false;

        yield LoadedState(
          movie: movie!,
          watchListHasMovie: watchListHasMovie,
          currentUser: _currentUser,
          otherCritiques: _otherCritiques,
        );
      } catch (error) {
        _createCritiqueBlocDelegate!.showMessage(
          message: error.toString(),
        );
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      final String critiqueText = event.critique;
      final double rating = event.rating;

      try {
        CritiqueModel critique = CritiqueModel(
          id: null,
          uid: _currentUser.uid!,
          imdbID: movie!.imdbID,
          message: critiqueText,
          genres: movie!.genre.split(', '),
          likes: [],
          rating: rating,
          comments: [],
          created: DateTime.now(),
          modified: DateTime.now(),
        );

        await locator<CritiqueService>().create(critique: critique);

        _createCritiqueBlocDelegate!.clearText();

        _createCritiqueBlocDelegate!.showMessage(
            message: 'Critique added, check it out on the home page.');

        yield LoadedState(
          movie: movie!,
          watchListHasMovie: watchListHasMovie,
          currentUser: _currentUser,
          otherCritiques: _otherCritiques,
        );
      } catch (error) {
        _createCritiqueBlocDelegate!
            .showMessage(message: 'Error ${error.toString()}!');

        yield LoadedState(
          movie: movie!,
          watchListHasMovie: watchListHasMovie,
          currentUser: _currentUser,
          otherCritiques: _otherCritiques,
        );
      }
    }
  }
}
