import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/NewCommentModel.dart';
import 'package:critic/models/NewCritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/MovieService.dart';
import 'package:critic/services/NewCritiqueService.dart';
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
        // await locator<NewCritiqueService>().addComment(
        //   id: '606a2057ee64f8927f5f5de7',
        //   comment: NewCommentModel(
        //     comment: 'I agree bro.',
        //     likes: [],
        //     uid: _currentUser.uid,
        //   ),
        // );

        // await locator<NewCritiqueService>().update(
        //   id: '606a2057ee64f8927f5f5de7',
        //   params: {
        //     'comments': [
        // NewCommentModel(
        //   comment: 'I agree bro.',
        //   likes: [],
        //   uid: _currentUser.uid,
        // ).toJson()
        //     ],
        //   },
        // );

        // var s = locator<NewCritiqueService>().create(
        //   critique: NewCritiqueModel(
        //     id: null,
        //     message: 'Hello bobby brown!',
        //     imdbID: 'tt10977680',
        //     uid: 'OkiieQJ7LhbyQwrCEFtOOP9b3Pt2',
        //     comments: [],
        //     created: DateTime.now(),
        //     rating: 3,
        //     likes: [],
        //   ),
        // );

        // var s = await locator<NewCritiqueService>()
        //     .list(uid: 'OkiieQJ7LhbyQwrCEFtOOP9b3Pt2');

        // final List<MovieModel> popularMovies =
        //     await locator<MovieService>().getPopularMovies();

        // final List<UserModel> mostRecentUsers =
        //     await locator<UserService>().retrieveUsers(
        //   limit: 10,
        //   orderBy: 'created',
        // );

        // final int critiqueCount =
        //     await locator<CritiqueService>().getTotalCritiqueCount();

        // final int userCount = await locator<UserService>().getTotalUserCount();

        yield HomeLoadedState(
          currentUser: _currentUser,
          mostRecentUsers: [],
          popularMovies: [],
          critiqueCount: 0,
          userCount: 0,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
