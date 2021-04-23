import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WatchlistBlocDelegate {
  void showMessage({@required String message});
}

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(null);
  WatchlistBlocDelegate _watchlistBlocDelegate;
  UserModel currentUser;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required WatchlistBlocDelegate delegate}) {
    this._watchlistBlocDelegate = delegate;
  }

  @override
  Stream<WatchlistState> mapEventToState(WatchlistEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        Stream<QuerySnapshot> watchlistStream = await locator<UserService>()
            .streamMoviesFromWatchlist(uid: currentUser.uid);

        watchlistStream.listen(
          (QuerySnapshot event) {
            List<MovieModel> movies =
                event.docs.map((doc) => MovieModel.fromDoc(ds: doc)).toList();

            add(WatchlistUpdatedEvent(movies: movies));
          },
        );
      } catch (error) {
        _watchlistBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is WatchlistUpdatedEvent) {
      final List<MovieModel> movies = event.movies;

      if (movies.isEmpty) {
        yield EmptyWatchlistState();
      } else {
        movies.sort(
          (a, b) => b.addedToWatchList.compareTo(a.addedToWatchList),
        );
        yield LoadedState(movies: movies);
      }
    }
  }
}
