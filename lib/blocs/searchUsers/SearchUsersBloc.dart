import 'dart:async';
import 'package:critic/blocs/searchMovies/SearchMoviesRepository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'SearchUsersEvent.dart';
import 'SearchUsersRepository.dart';
import 'SearchUsersState.dart';

class SearchUsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  final SearchUsersRepository searchUsersRepository;

  SearchUsersBloc({@required this.searchUsersRepository});

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

  @override
  SearchUsersState get initialState => SearchUsersStateEmpty();

  @override
  Stream<SearchUsersState> mapEventToState(
    SearchUsersEvent event,
  ) async* {
    if (event is TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchUsersStateEmpty();
      } else {
        yield SearchUsersStateLoading();
        try {
          final results = await searchUsersRepository.search(searchTerm);
          yield SearchUsersStateSuccess(users: results);
        } catch (error) {
          yield SearchUsersStateError(error: error);
        }
      }
    }
  }
}
