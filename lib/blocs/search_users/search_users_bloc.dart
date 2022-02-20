import 'dart:async';
import 'package:critic/models/data/user_model.dart';
import 'package:critic/initialize_dependencies.dart';
import 'package:critic/services/auth_service.dart';
import 'package:critic/services/block_user_service.dart';
import 'package:critic/services/user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/blocs/other_profile/other_profile_bloc.dart'
    as OTHER_PROFILE_BP;
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:algolia/algolia.dart';
import '../../constants.dart';

part 'search_users_cache.dart';
part 'search_users_event.dart';
part 'search_users_page.dart';
part 'search_users_repository.dart';
part 'search_users_state.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final SearchUsersRepository searchUsersRepository;
  SearchUsersBloc({required this.searchUsersRepository})
      : super(
          SearchUsersStateStart(),
        );

  @override
  Stream<Transition<SearchUsersEvent, SearchUsersState>> transformEvents(
    Stream<SearchUsersEvent> events,
    Stream<Transition<SearchUsersEvent, SearchUsersState>> Function(
      SearchUsersEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(Transition<SearchUsersEvent, SearchUsersState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  late UserModel _currentUser;
  late List<String> _usersIBlockedIDs;
  late List<String> _usersWhoBlockedMeIDs;

  @override
  Stream<SearchUsersState> mapEventToState(
    SearchUsersEvent event,
  ) async* {
    if (event is LoadPageEvent) {
      try {
        _currentUser = await locator<AuthService>().getCurrentUser();
        _usersIBlockedIDs = await locator<BlockUserService>()
            .getUsersIBlockedIDs(userID: _currentUser.uid);

        _usersWhoBlockedMeIDs = await locator<BlockUserService>()
            .getUsersWhoBlockedMeIDs(userID: _currentUser.uid);
      } catch (error) {
        print(error.toString()); //todo: Display error message.
      }
    }

    if (event is TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchUsersStateStart();
      } else {
        yield SearchUsersStateLoading();
        try {
          final List<UserModel> results =
              await searchUsersRepository.search(searchTerm);

          results.removeWhere(
            (user) =>
                _usersIBlockedIDs.contains(user.uid) ||
                _usersWhoBlockedMeIDs.contains(user.uid),
          );

          results.removeWhere((user) => user.uid == _currentUser.uid);

          if (results.isEmpty) {
            yield SearchUsersStateNoResults();
          } else {
            yield SearchUsersStateFoundResults(users: results);
          }
        } catch (error) {
          yield SearchUsersStateError(error: error);
        }
      }
    }
  }
}
