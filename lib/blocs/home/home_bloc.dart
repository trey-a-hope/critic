import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/constants.dart';
import 'package:critic/models/critique_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:critic/widgets/small_critique_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_version/new_version.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;

part 'home_event.dart';
part 'home_state.dart';
part 'home_page.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  late UserModel _currentUser;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    yield HomeLoadingState();

    if (event is LoadPageEvent) {
      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        // final List<MovieModel> popularMovies =
        //     await locator<MovieService>().getPopularMovies();

        final List<UserModel> mostRecentUsers =
            await locator<UserService>().retrieveUsers(
          limit: 5,
          orderBy: 'created',
        );

        final List<CritiqueModel> mostRecentCritiques =
            await locator<CritiqueService>().list(limit: 5);

        // final int critiqueCount =
        //     await locator<CritiqueService>().count(uid: null);

        final int userCount = await locator<UserService>().getTotalUserCount();

        yield HomeLoadedState(
          currentUser: _currentUser,
          mostRecentUsers: mostRecentUsers,
          // popularMovies: popularMovies,
          mostRecentCritiques: mostRecentCritiques,
          // critiqueCount: critiqueCount,
          userCount: userCount,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
