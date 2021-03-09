import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/blocs/searchUsers/Bloc.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/RecommendationModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/FCMNotificationService.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/services/RecommendationsService.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:critic/blocs/searchMovies/Bloc.dart' as SEARCH_MOVIES_BP;
import 'package:critic/blocs/searchUsers/Bloc.dart' as SEARCH_USERS_BP;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'create_recommendation_event.dart';
part 'create_recommendation_state.dart';
part 'create_recommendation_page.dart';

class CreateRecommendationBloc
    extends Bloc<CreateRecommendationEvent, CreateRecommendationState> {
  CreateRecommendationBloc() : super(CreateRecommendationInitial());

  UserModel _currentUser;
  MovieModel _selectedMovie;
  UserModel _selectedUser;

  SearchUsersRepository searchUsersRepository;

  Stream<CreateRecommendationState> mapEventToState(
    CreateRecommendationEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          selectedMovie: _selectedMovie,
          selectedUser: _selectedUser,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitRecommendationEvent) {
      final String message = event.message;

      yield LoadingState();

      await locator<RecommendationsService>().createRecommendation(
        sendeeUID: _selectedUser.uid,
        recommendation: RecommendationModel(
          id: null,
          message: message,
          imdbID: _selectedMovie.imdbID,
          senderUID: _currentUser.uid,
          created: DateTime.now(),
        ),
      );

      //Send notification to user.
      if (_selectedUser.fcmToken != null) {
        //Send notification to user.
        await locator<FCMNotificationService>().sendNotificationToUser(
          fcmToken: _selectedUser.fcmToken,
          title: 'New movie recommendation!',
          body: '${_selectedMovie.title}',
          notificationData: null,
        );
      }

      yield SuccessState();
    }

    if (event is UpdateSelectedMovieEvent) {
      _selectedMovie = event.movie;
      yield LoadedState(
        selectedMovie: _selectedMovie,
        selectedUser: _selectedUser,
      );
    }

    if (event is UpdateSelectedUserEvent) {
      _selectedUser = event.user;
      yield LoadedState(
        selectedMovie: _selectedMovie,
        selectedUser: _selectedUser,
      );
    }
  }
}
