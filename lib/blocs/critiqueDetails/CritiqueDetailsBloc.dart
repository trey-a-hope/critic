import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/CritiqueStatsModel.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FCMNotificationService.dart';
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

  DocumentSnapshot similarCritiquesStartAfterDocument;

  DocumentSnapshot commentsStartAfterDocument;

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

        CritiqueStatsModel critiqueStats =
            await locator<CritiqueService>().critiqueStats(
          uid: _currentUser.uid,
          critiqueID: critiqueModel.id,
        );

        bool isLiked = critiqueStats.isLiked;
        critiqueModel.likeCount = critiqueStats.likeCount;

        yield LoadedState(
          currentUser: _currentUser,
          critiqueUser: _critiqueUser,
          critiqueModel: critiqueModel,
          movieModel: movieModel,
          isLiked: isLiked,
          likeCount: critiqueModel.likeCount,
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

    if (event is LikeCritiqueEvent) {
      try {
        await locator<CritiqueService>().likeCritique(
          uid: _currentUser.uid,
          critiqueID: critiqueModel.id,
        );

        if (_currentUser.uid != _critiqueUser.uid &&
            _critiqueUser.fcmToken != null) {
          //Send notification to user.
          await locator<FCMNotificationService>().sendNotificationToUser(
            fcmToken: _critiqueUser.fcmToken,
            title: '${_currentUser.username} liked your critique!',
            body: '${critiqueModel.movieTitle}',
            notificationData: null,
          );
        }

        critiqueModel.likeCount++;

        yield LoadedState(
          currentUser: _currentUser,
          critiqueUser: _critiqueUser,
          critiqueModel: critiqueModel,
          movieModel: movieModel,
          isLiked: true,
          likeCount: critiqueModel.likeCount,
        );
      } catch (error) {
        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is UnlikeCritiqueEvent) {
      try {
        await locator<CritiqueService>().unlikeCritique(
          uid: _currentUser.uid,
          critiqueID: critiqueModel.id,
        );

        critiqueModel.likeCount--;

        yield LoadedState(
          currentUser: _currentUser,
          critiqueUser: _critiqueUser,
          critiqueModel: critiqueModel,
          movieModel: movieModel,
          isLiked: false,
          likeCount: critiqueModel.likeCount,
        );
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
