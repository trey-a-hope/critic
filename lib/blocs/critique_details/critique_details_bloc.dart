import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:critic/models/comment_model.dart';
import 'package:critic/models/critique_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/fcm_notification_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/validation_service.dart';
import 'package:critic/widgets/small_critique_view.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/pages/likes_page.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_stack/image_stack.dart';
import '../../Constants.dart';
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

part 'critique_details_event.dart';
part 'critique_details_state.dart';
part 'critique_details_page.dart';

abstract class CritiqueDetailsBlocDelegate {
  void showMessage({required String title, required String message});
  void clearText();
  void pop();
}

class CritiqueDetailsBloc
    extends Bloc<CritiqueDetailsEvent, CritiqueDetailsState> {
  CritiqueDetailsBloc({
    required this.critiqueID,
  }) : super(
          CritiqueDetailsState(),
        );

  final String critiqueID;

  late CritiqueModel _critiqueModel;

  CritiqueDetailsBlocDelegate? _critiqueDetailsBlocDelegate;

  late UserModel _currentUser;

  late UserModel _critiqueUser;

  void setDelegate({required CritiqueDetailsBlocDelegate delegate}) {
    this._critiqueDetailsBlocDelegate = delegate;
  }

  @override
  Stream<CritiqueDetailsState> mapEventToState(
      CritiqueDetailsEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _critiqueModel = await locator<CritiqueService>().get(id: critiqueID);

        _critiqueUser = await locator<UserService>().retrieveUser(
          uid: _critiqueModel.uid,
        );

        // CritiqueStatsModel critiqueStats =
        //     await locator<CritiqueService>().critiqueStats(
        //   uid: _currentUser.uid,
        //   critiqueID: critiqueModel.id,
        // );

        //Fetch users for likes.
        List<UserModel> likedUsers = [];
        for (int i = 0; i < _critiqueModel.likes.length; i++) {
          UserModel likedUser = await locator<UserService>()
              .retrieveUser(uid: _critiqueModel.likes[i]);
          likedUsers.add(likedUser);
        }

        //Determine if this user has liked this critique or not.
        bool isLiked = _critiqueModel.likes.contains(_currentUser.uid);

        //Fetch users for comments.
        for (int i = 0; i < _critiqueModel.comments.length; i++) {
          UserModel commentUser = await locator<UserService>()
              .retrieveUser(uid: _critiqueModel.comments[i].uid);
          _critiqueModel.comments[i].user = commentUser;
        }

        //Reverse comments to get most recent on top.
        _critiqueModel.comments = _critiqueModel.comments.reversed.toList();

        List<CritiqueModel> otherCritiques =
            await locator<CritiqueService>().listSimilar(
          id: _critiqueModel.id,
          imdbID: _critiqueModel.movie!.imdbID,
        );

        yield LoadedState(
          currentUser: _currentUser,
          critiqueUser: _critiqueUser,
          critiqueModel: _critiqueModel,
          isLiked: isLiked,
          likedUsers: likedUsers,
          otherCritiques: otherCritiques,
        );
      } catch (error) {
        _critiqueDetailsBlocDelegate!.showMessage(
          title: 'Error',
          message: 'Error: ${error.toString()}',
        );
        yield ErrorState(error: error);
      }
    }

    if (event is DeleteCritiqueEvent) {
      try {
        await locator<CritiqueService>().delete(
          id: _critiqueModel.id!,
        );

        _critiqueDetailsBlocDelegate!.showMessage(
            title: 'Deleted', message: 'Refresh home page to see results.');
      } catch (error) {
        _critiqueDetailsBlocDelegate!
            .showMessage(title: 'Error', message: 'Error: ${error.toString()}');
      }
    }

    if (event is ReportCritiqueEvent) {
      try {
        await locator<CritiqueService>().delete(
          id: _critiqueModel.id!,
        );

        _critiqueDetailsBlocDelegate!.showMessage(
          title: 'Reported',
          message: 'Critique reported, you will no longer see this critique.',
        );
      } catch (error) {
        _critiqueDetailsBlocDelegate!.showMessage(
          title: 'Error',
          message: 'Error: ${error.toString()}',
        );
      }
    }

    if (event is LikeCritiqueEvent) {
      try {
        await locator<CritiqueService>().addLike(
          id: _critiqueModel.id!,
          uid: _currentUser.uid!,
        );

        if (_currentUser.uid != _critiqueUser.uid &&
            _critiqueUser.fcmToken != null) {
          //Send notification to user.
          await locator<FCMNotificationService>().sendNotificationToUser(
            fcmToken: _critiqueUser.fcmToken!,
            title: '${_currentUser.username} liked your critique!',
            body: '${_critiqueModel.movie!.title}',
            notificationData: null,
          );
        }

        add(LoadPageEvent());
      } catch (error) {
        _critiqueDetailsBlocDelegate!.showMessage(
          title: 'Error',
          message: 'Error: ${error.toString()}',
        );
      }
    }

    if (event is UnlikeCritiqueEvent) {
      try {
        await locator<CritiqueService>().removeLike(
          id: _critiqueModel.id!,
          uid: _currentUser.uid!,
        );

        add(LoadPageEvent());
      } catch (error) {
        _critiqueDetailsBlocDelegate!.showMessage(
          title: 'Error',
          message: 'Error: ${error.toString()}',
        );
      }
    }

    if (event is PostCommentEvent) {
      final String comment = event.comment;

      try {
        await locator<CritiqueService>().addComment(
          id: critiqueID,
          comment: CommentModel(
            uid: _currentUser.uid!,
            comment: comment,
            likes: [],
          ),
        );

        //Send notification to user who created critique.
        if (_currentUser.uid != _critiqueUser.uid &&
            _critiqueUser.fcmToken != null) {
          await locator<FCMNotificationService>().sendNotificationToUser(
            fcmToken: _critiqueUser.fcmToken!,
            title: '${_currentUser.username} commented on your critique!',
            body: '${_critiqueModel.movie!.title}',
            notificationData: null,
          );
        }

        //Send notification to all users who commented.
        for (int i = 0; i < _critiqueModel.comments.length; i++) {
          final UserModel commentUser = _critiqueModel.comments[i].user!;
          if (_currentUser.uid != _critiqueModel.comments[i].uid &&
              commentUser.fcmToken != null) {
            await locator<FCMNotificationService>().sendNotificationToUser(
              fcmToken: commentUser.fcmToken!,
              title:
                  '${_currentUser.username} commented on a critique you commented on!',
              body: '${_critiqueModel.movie!.title}',
              notificationData: null,
            );
          }
        }

        _critiqueDetailsBlocDelegate!.clearText();

        add(LoadPageEvent());
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
