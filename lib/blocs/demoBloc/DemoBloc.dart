import 'package:flutter/material.dart';
import 'Bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DemoBlocDelegate {
  void showMessage({@required String message});
}

class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc() : super(null);
  DemoBlocDelegate _demoBlocDelegate;

  void setDelegate({@required DemoBlocDelegate delegate}) {
    this._demoBlocDelegate = delegate;
  }

  @override
  Stream<DemoState> mapEventToState(DemoEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        yield LoadedState();
      } catch (error) {
        _demoBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
      }
    }
  }
}
