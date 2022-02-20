import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/blocs/search_users/search_users_bloc.dart'
    as SEARCH_USERS_BP;
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/recommendation_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/initialize_dependencies.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/fcm_notification_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/recommendations_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/Spinner.dart';
// import 'package:critic/blocs/search_movies/search_movies_bloc.dart'
//     as SEARCH_MOVIES_BP;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'create_recommendation_event.dart';

part 'create_recommendation_state.dart';

part 'create_recommendation_page.dart';

class CreateRecommendationBloc
    extends Bloc<CreateRecommendationEvent, CreateRecommendationState> {
  CreateRecommendationBloc() : super(CreateRecommendationInitial());

  late UserModel _currentUser;
  MovieModel? _selectedMovie;
  UserModel? _selectedUser;

  //SEARCH_USERS_BP.SearchUsersRepository? searchUsersRepository;

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
        sendeeUID: _selectedUser!.uid!,
        recommendation: RecommendationModel(
          message: message,
          imdbID: _selectedMovie!.imdbID,
          uid: _currentUser.uid!,
          created: DateTime.now(),
        ),
      );

      //Send notification to user.
      if (_selectedUser!.fcmToken != null) {
        await locator<FCMNotificationService>().sendNotificationToUser(
          fcmToken: _selectedUser!.fcmToken!,
          title: 'New movie recommendation!',
          body: '${_selectedMovie!.title}',
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
