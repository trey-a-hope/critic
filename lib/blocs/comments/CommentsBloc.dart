import 'package:bloc/bloc.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/CritiqueService.dart';
import 'package:flutter/material.dart';
import 'Bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentsBlocDelegate {
  void showMessage({@required String message});
}

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({
    @required this.currentUser,
    @required this.critique,
  }) : super(null);

  final UserModel currentUser;
  final CritiqueModel critique;

  CommentsBlocDelegate _commentsBlocDelegate;

  int limit = 10;

  DocumentSnapshot startAfterDocument;

  void setDelegate({@required CommentsBlocDelegate delegate}) {
    this._commentsBlocDelegate = delegate;
  }

  @override
  Stream<CommentsState> mapEventToState(CommentsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        startAfterDocument = null;

        yield LoadedState(
          currentUser: currentUser,
        );
      } catch (error) {
        _commentsBlocDelegate.showMessage(
            message: 'Error: ${error.toString()}');
      }
    }

    if (event is DeleteCommentEvent) {
      final String commentID = event.commentID;
      try {
        yield LoadingState();

        await locator<CritiqueService>().deleteComment(
          critiqueID: critique.id,
          commentID: commentID,
        );

        _commentsBlocDelegate.showMessage(message: 'Commment deleted.');

        add(LoadPageEvent());
      } catch (error) {
        _commentsBlocDelegate.showMessage(message: error.toString());
        yield LoadedState(currentUser: currentUser);
      }
    }

    if (event is ReportCommentEvent) {
      final String commentID = event.commentID;
      try {
        yield LoadingState();

        await locator<CritiqueService>().deleteComment(
          critiqueID: critique.id,
          commentID: commentID,
        );

        _commentsBlocDelegate.showMessage(message: 'Commment reported.');
        add(LoadPageEvent());
      } catch (error) {
        _commentsBlocDelegate.showMessage(message: error.toString());
        yield LoadedState(currentUser: currentUser);
      }
    }
  }
}
