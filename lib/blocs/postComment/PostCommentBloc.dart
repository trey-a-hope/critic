import 'package:bloc/bloc.dart';
import 'package:critic/models/CommentModel.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:critic/services/FCMNotificationService.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';
import 'PostCommentEvent.dart';
import 'PostCommentState.dart';

abstract class PostCommentBlocDelegate {
  void showMessage({@required String message});
  void clearText();
}

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  PostCommentBloc({
    @required this.critique,
    @required this.critiqueUser,
  }) : super(null);
  final CritiqueModel critique;
  final UserModel critiqueUser;

  PostCommentBlocDelegate _postCommentBlocDelegate;
  UserModel _currentUser;

  void setDelegate({@required PostCommentBlocDelegate delegate}) {
    this._postCommentBlocDelegate = delegate;
  }

  @override
  Stream<PostCommentState> mapEventToState(PostCommentEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState();
      } catch (error) {
        _postCommentBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
        yield LoadedState();
      }
    }

    if (event is SubmitEvent) {
      yield LoadingState();

      final String message = event.message;

      try {
        CommentModel comment = CommentModel(
          created: DateTime.now(),
          id: null,
          message: message,
          uid: _currentUser.uid,
        );

        await locator<CritiqueService>().createComment(
          critiqueID: critique.id,
          comment: comment,
        );

        if (_currentUser.uid != critiqueUser.uid &&
            critiqueUser.fcmToken != null) { 
          await locator<FCMNotificationService>().sendNotificationToUser(
            fcmToken: critiqueUser.fcmToken,
            title: 'Someone commented on your critique.',
            body: '${_currentUser.username}',
            notificationData: null,
          );
        }

        _postCommentBlocDelegate.clearText();

        _postCommentBlocDelegate.showMessage(message: 'Comment added.');

        yield LoadedState();
      } catch (error) {
        _postCommentBlocDelegate.showMessage(
            message: 'Error ${error.toString()}!');

        yield LoadedState();
      }
    }
  }
}
