import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class HomeBlocDelegate {
  void showMessage({@required String message});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(
          HomeState(),
        );

  final FirebaseMessaging _fcm = FirebaseMessaging();

  HomeBlocDelegate _homeBlocDelegate;

  UserModel currentUser;

  int limit = 10;

  void setDelegate({@required HomeBlocDelegate delegate}) {
    this._homeBlocDelegate = delegate;
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  //Request notification permissions and register call backs for receiving push notifications.
  void _setUpFirebaseMessaging() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    final String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      locator<UserService>()
          .updateUser(uid: currentUser.uid, data: {'fcmToken': fcmToken});
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        currentUser = await locator<AuthService>().getCurrentUser();

        _setUpFirebaseMessaging();

        locator<CritiqueService>().followStats(uid: currentUser.uid);

        yield LoadedState(currentUser: currentUser);
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
