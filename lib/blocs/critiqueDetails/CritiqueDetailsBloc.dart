import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/BlockUserService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class CritiqueDetailsBlocDelegate {
  void showMessage({@required String message});
}

class CritiqueDetailsBloc
    extends Bloc<CritiqueDetailsEvent, CritiqueDetailsState> {
  CritiqueDetailsBloc({
    @required this.critiqueModel,
  }) : super(
          CritiqueDetailsState(),
        );
  final CritiqueModel critiqueModel;

  CritiqueDetailsBlocDelegate _critiqueDetailsBlocDelegate;

  UserModel _currentUser;

  UserModel _critiqueUser;

  MovieModel movieModel;

  void setDelegate({@required CritiqueDetailsBlocDelegate delegate}) {
    this._critiqueDetailsBlocDelegate = delegate;
  }

  @override
  Stream<CritiqueDetailsState> mapEventToState(
      CritiqueDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _critiqueUser = await locator<UserService>().retrieveUser(
          uid: critiqueModel.uid,
        );

        movieModel = await locator<MovieService>()
            .getMovieByID(id: critiqueModel.imdbID);

        yield LoadedState(
          currentUser: _currentUser,
          critiqueUser: _critiqueUser,
          critiqueModel: critiqueModel,
          movieModel: movieModel,
        );
      } catch (error) {
        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
        yield ErrorState(error: error);
      }
    }

    if (event is DeleteCritiqueEvent) {
      try {
        await locator<CritiqueService>().deleteCritique(
          critiqueID: critiqueModel.id,
          uid: critiqueModel.uid,
        );

        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Critique deleted, refresh home page to see results.');
      } catch (error) {
        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is ReportCritiqueEvent) {
      try {
        await locator<CritiqueService>().deleteCritique(
          critiqueID: critiqueModel.id,
          uid: critiqueModel.uid,
        );

        _critiqueDetailsBlocDelegate.showMessage(
            message:
                'Critique reported, you will no longer see this critique.');
      } catch (error) {
        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
