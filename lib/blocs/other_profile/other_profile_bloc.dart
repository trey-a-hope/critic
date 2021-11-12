import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/service_locator.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/modal_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:critic/services/util_service.dart';
import 'package:critic/widgets/critique_view.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/constants.dart';
import 'package:critic/models/critique_model.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:pagination_view/pagination_view.dart';

part 'other_profile_event.dart';
part 'other_profile_state.dart';
part 'other_profile_page.dart';

abstract class OtherProfileBlocDelegate {
  void navigateHome();
  void showMessage({required String message});
}

class OtherProfileBloc extends Bloc<OtherProfileEvent, OtherProfileState> {
  OtherProfileBloc({
    required this.otherUserID,
  }) : super(InitialState());

  final String otherUserID;

  OtherProfileBlocDelegate? _otherProfileBlocDelegate;

  late UserModel currentUser;
  late UserModel otherUser;

  void setDelegate({required OtherProfileBlocDelegate delegate}) {
    this._otherProfileBlocDelegate = delegate;
  }

  @override
  Stream<OtherProfileState> mapEventToState(OtherProfileEvent event) async* {
    if (event is LoadPageEvent) {
      yield LoadingState();

      try {
        otherUser = await locator<UserService>().retrieveUser(uid: otherUserID);

        currentUser = await locator<AuthService>().getCurrentUser();

        yield LoadedState(
          otherUser: otherUser,
          currentUser: currentUser,
        );
      } catch (error) {
        _otherProfileBlocDelegate!
            .showMessage(message: 'Error: ${error.toString()}');

        yield LoadedState(
          otherUser: otherUser,
          currentUser: currentUser,
        );
      }
    }
  }
}
