import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FollowerService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';

abstract class CritiqueDetailsBlocDelegate {
  void showMessage({@required String message});
}

class CritiqueDetailsBloc
    extends Bloc<CritiqueDetailsEvent, CritiqueDetailsState> {
  CritiqueDetailsBloc({
    @required this.critiqueModel,
  }) : super(
          CritiqueDetailsState(),
        );

  CritiqueDetailsBlocDelegate _critiqueDetailsBlocDelegate;
  UserModel _currentUser;
  final CritiqueModel critiqueModel;

  void setDelegate({@required CritiqueDetailsBlocDelegate delegate}) {
    this._critiqueDetailsBlocDelegate = delegate;
  }

  @override
  Stream<CritiqueDetailsState> mapEventToState(
      CritiqueDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          currentUser: _currentUser,
          critiqueModel: critiqueModel,
        );

        // List<CritiqueModel> critiques =
        //     await locator<CritiqueService>().retrieveCritiques(
        //   safe: true,
        //   uid: _currentUser.uid,
        //   limit: 100,
        //   offset: 0,
        // );

        // if (critiques.isEmpty) {
        //   yield NoCritiquesState();
        // } else {
        //   yield FoundCritiquesState(
        //     critiques: critiques,
        //     currentUser: _currentUser,
        //   );
        // }
      } catch (error) {
        _critiqueDetailsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
        yield ErrorState(error: error);
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
