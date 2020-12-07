import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/UserService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  int limit = 25;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required ExploreBlocDelegate delegate}) {
    this._exploreBlocDelegate = delegate;
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
        _exploreBlocDelegate.showMessage(
          title: '${message['aps']['alert']['title']}',
          body: '${message['aps']['alert']['body']}',
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        startAfterDocument = null;

        currentUser = await locator<AuthService>().getCurrentUser();

        _setUpFirebaseMessaging();
        yield LoadedState(
          currentUser: currentUser,
          pageFetchLimit: 25,
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
