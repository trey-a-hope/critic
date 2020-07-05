import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class HomeBlocDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
          HomeState(),
        );

  HomeBlocDelegate _homeBlocDelegate;

  void setDelegate({@required HomeBlocDelegate delegate}) {
    this._homeBlocDelegate = delegate;
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        List<CritiqueModel> critiques =
            await locator<CritiqueService>().retrieveCritiques();
            
        if (critiques.isEmpty) {
          yield NoCritiquesState();
        } else {
          yield FoundCritiquesState(critiques: critiques);
        }
      } catch (error) {
        _homeBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
        yield ErrorState(error: error);
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
