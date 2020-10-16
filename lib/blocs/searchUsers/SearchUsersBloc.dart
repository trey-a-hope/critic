import 'dart:async';
import 'package:critic/models/UserModel.dart';
import 'package:critic/services/AuthService.dart';
import 'package:critic/services/BlockUserService.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import '../../ServiceLocator.dart';
import 'Bloc.dart' as SEARCH_USERS_BP;

class SearchUsersBloc extends Bloc<SEARCH_USERS_BP.SearchUsersEvent,
    SEARCH_USERS_BP.SearchUsersState> {
  final SEARCH_USERS_BP.SearchUsersRepository searchUsersRepository;
  SearchUsersBloc({@required this.searchUsersRepository})
      : super(
          SEARCH_USERS_BP.SearchUsersStateStart(),
        );

  @override
  Stream<
      Transition<SEARCH_USERS_BP.SearchUsersEvent,
          SEARCH_USERS_BP.SearchUsersState>> transformEvents(
    Stream<SEARCH_USERS_BP.SearchUsersEvent> events,
    Stream<
                Transition<SEARCH_USERS_BP.SearchUsersEvent,
                    SEARCH_USERS_BP.SearchUsersState>>
            Function(
      SEARCH_USERS_BP.SearchUsersEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<SEARCH_USERS_BP.SearchUsersEvent,
              SEARCH_USERS_BP.SearchUsersState>
          transition) {
    print(transition);
    super.onTransition(transition);
  }

  UserModel _currentUser;
  List<String> _usersIBlockedIDs;
  List<String> _usersWhoBlockedMeIDs;

  @override
  Stream<SEARCH_USERS_BP.SearchUsersState> mapEventToState(
    SEARCH_USERS_BP.SearchUsersEvent event,
  ) async* {
    if (event is SEARCH_USERS_BP.LoadPageEvent) {
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

    if (event is SEARCH_USERS_BP.TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SEARCH_USERS_BP.SearchUsersStateStart();
      } else {
        yield SEARCH_USERS_BP.SearchUsersStateLoading();
        try {
          final List<UserModel> results =
              await searchUsersRepository.search(searchTerm);

          results.removeWhere(
            (user) =>
                _usersIBlockedIDs.contains(user.uid) ||
                _usersWhoBlockedMeIDs.contains(user.uid),
          );

          if (results.isEmpty) {
            yield SEARCH_USERS_BP.SearchUsersStateNoResults();
          } else {
            yield SEARCH_USERS_BP.SearchUsersStateFoundResults(users: results);
          }
        } catch (error) {
          yield SEARCH_USERS_BP.SearchUsersStateError(error: error);
        }
      }
    }
  }
}
