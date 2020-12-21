import 'package:critic/blocs/web/Bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'package:bloc/bloc.dart';

abstract class WebBlocDelegate {
  void showMessage({@required String message});
}

class WebBloc extends Bloc<WebEvent, WebState> {
  WebBloc() : super(null);
  WebBlocDelegate _webBlocDelegate;

  void setDelegate({@required WebBlocDelegate delegate}) {
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
