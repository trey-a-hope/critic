import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
part 'web_event.dart';
part 'web_state.dart';
part 'web_page.dart';

abstract class WebBlocDelegate {
  void showMessage({required String message});
}

class WebBloc extends Bloc<WebEvent, WebState> {
  WebBloc() : super(InitialState());
  WebBlocDelegate? _webBlocDelegate;

  void setDelegate({required WebBlocDelegate delegate}) {
    this._webBlocDelegate = delegate;
  }

  @override
  Stream<WebState> mapEventToState(WebEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        print('Page loaded...');

        List<UserModel> topFiveRecentUsers = await locator<UserService>()
            .retrieveUsers(limit: 5, orderBy: 'created');

        List<UserModel> topFiveCritiquesUsers = await locator<UserService>()
            .retrieveUsers(limit: 5, orderBy: 'critiqueCount');

        yield LoadedState(
          topFiveRecentUsers: topFiveRecentUsers,
          topFiveCritiquesUsers: topFiveCritiquesUsers,
        );
      } catch (error) {
        print(error);
        yield ErrorState(error: error);
        // _webBlocDelegate.showMessage(message: 'Error: ${error.toString()}');
      }
    }
  }
}
