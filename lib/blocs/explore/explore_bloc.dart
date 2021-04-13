import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/widgets/CritiqueView.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/services/ModalService.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pagination/pagination.dart';

part 'explore_page.dart';
part 'explore_state.dart';
part 'explore_event.dart';

abstract class ExploreBlocDelegate {
  void showMessage({
    @required String title,
    @required String body,
  });
}

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc()
      : super(
          ExploreState(),
        );

  final FirebaseMessaging _fcm = FirebaseMessaging();

  ExploreBlocDelegate _exploreBlocDelegate;

  UserModel currentUser;

  void setDelegate({@required ExploreBlocDelegate delegate}) {
    this._exploreBlocDelegate = delegate;
  }

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          currentUser: currentUser,
        );
      } catch (error) {
        _exploreBlocDelegate.showMessage(
          title: 'Error',
          body: error.toString(),
        );
        yield ErrorState(error: error);
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
