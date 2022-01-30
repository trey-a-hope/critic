import 'dart:async';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/widgets/explore_list.dart';
import 'package:critic/widgets/explore_tab.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';

part 'explore_page.dart';
part 'explore_state.dart';
part 'explore_event.dart';

abstract class ExploreBlocDelegate {
  void showMessage({
    required String title,
    required String body,
  });
}

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc()
      : super(
          ExploreState(),
        );

  ExploreBlocDelegate? _exploreBlocDelegate;

  late UserModel currentUser;

  void setDelegate({required ExploreBlocDelegate delegate}) {
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
        _exploreBlocDelegate!.showMessage(
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
