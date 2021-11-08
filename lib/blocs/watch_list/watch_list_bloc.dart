import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/Constants.dart';
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;
import 'package:critic/widgets/Spinner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'watch_list_event.dart';
part 'watch_list_state.dart';
part 'watch_list_page.dart';

abstract class WatchlistBlocDelegate {
  void showMessage({required String message});
}

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(InitialState());
  WatchlistBlocDelegate? _watchlistBlocDelegate;
  late UserModel currentUser;

  DocumentSnapshot? startAfterDocument;

  void setDelegate({required WatchlistBlocDelegate delegate}) {
    this._watchlistBlocDelegate = delegate;
  }

  @override
  Stream<WatchlistState> mapEventToState(WatchlistEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> watchlistStream = await locator<UserService>()
            .streamMoviesFromWatchlist(uid: currentUser.uid!);

        watchlistStream.listen(
          (QuerySnapshot event) {
            List<MovieModel> movies =
                event.docs.map((doc) => MovieModel.fromDoc(data: doc)).toList();

            add(WatchlistUpdatedEvent(movies: movies));
          },
        );
      } catch (error) {
        _watchlistBlocDelegate!
            .showMessage(message: 'Error: ${error.toString()}');
      }
    }

    if (event is WatchlistUpdatedEvent) {
      final List<MovieModel> movies = event.movies;

      if (movies.isEmpty) {
        yield EmptyWatchlistState();
      } else {
        movies.sort(
          (a, b) => b.addedToWatchList!.compareTo(a.addedToWatchList!),
        );
        yield LoadedState(movies: movies);
      }
    }
  }
}
