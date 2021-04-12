import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/CommentModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/UserService.dart';
import 'package:critic/widgets/MovieWidget.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:critic/blocs/otherProfile/Bloc.dart' as OTHER_PROFILE_BP;

part 'home_event.dart';
part 'home_state.dart';
part 'home_page.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  UserModel _currentUser;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    yield HomeLoadingState();

    if (event is LoadPageEvent) {
      _currentUser = await locator<AuthService>().getCurrentUser();
      try {
        final List<MovieModel> popularMovies =
            await locator<MovieService>().getPopularMovies();

        final List<UserModel> mostRecentUsers =
            await locator<UserService>().retrieveUsers(
          limit: 10,
          orderBy: 'created',
        );

        // final int critiqueCount =
        //     await locator<CritiqueService>().count(uid: null);

        final int userCount = await locator<UserService>().getTotalUserCount();

        yield HomeLoadedState(
          currentUser: _currentUser,
          mostRecentUsers: mostRecentUsers,
          popularMovies: popularMovies,
          // critiqueCount: critiqueCount,
          userCount: userCount,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
