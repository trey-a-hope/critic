import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WatchlistBlocDelegate {
  void showMessage({@required String message});
}

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(null);
  WatchlistBlocDelegate _watchlistBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required WatchlistBlocDelegate delegate}) {
    this._watchlistBlocDelegate = delegate;
  }

  @override
  Stream<WatchlistState> mapEventToState(WatchlistEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState();
      } catch (error) {
        _watchlistBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }
  }
}
