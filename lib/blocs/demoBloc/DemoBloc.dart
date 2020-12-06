import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DemoBlocDelegate {
  void showMessage({@required String message});
}

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(null);
  DemoBlocDelegate _demoBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required DemoBlocDelegate delegate}) {
    this._demoBlocDelegate = delegate;
  }

  @override
  Stream<DemoState> mapEventToState(DemoEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState();
      } catch (error) {
        _demoBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
      }
    }
  }
}
