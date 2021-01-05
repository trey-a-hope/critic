import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:critic/models/SuggestionModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/SuggestionService.dart';
import 'package:critic/services/modal_service.dart';
import 'package:equatable/equatable.dart';
import 'package:critic/Constants.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/services/ValidationService.dart';
import 'package:critic/widgets/FullWidthButton.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'suggestions_event.dart';
part 'suggestions_state.dart';
part 'suggestions_view.dart';

class SuggestionsBloc extends Bloc<SuggestionsEvent, SuggestionsState> {
  SuggestionsBloc() : super(SuggestionsInitial());

  UserModel _currentUser;

  @override
  Stream<SuggestionsState> mapEventToState(
    SuggestionsEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      try {
        yield SuggestionsLoading();

        _currentUser = await locator<AuthService>().getCurrentUser();

        yield SuggestionsInitial();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      final String message = event.message;
      yield SuggestionsLoading();
      try {
        await locator<SuggestionService>().createSuggestion(
          suggestion: SuggestionModel(
            id: null,
            uid: _currentUser.uid,
            message: message,
            created: DateTime.now(),
          ),
        );

        yield SuggestionsSuccess();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
