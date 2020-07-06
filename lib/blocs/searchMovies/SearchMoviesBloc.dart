import 'dart:async';
import 'package:critic/blocs/searchMovies/SearchMoviesRepository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'SearchMoviesEvent.dart';
import 'SearchMoviesState.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMoviesRepository searchMoviesRepository;
  SearchMoviesBloc({@required this.searchMoviesRepository})
      : super(
          SearchMoviesStateEmpty(),
        );

  @override
  Stream<Transition<SearchMoviesEvent, SearchMoviesState>> transformEvents(
    Stream<SearchMoviesEvent> events,
    Stream<Transition<SearchMoviesEvent, SearchMoviesState>> Function(
      SearchMoviesEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  void onTransition(
      Transition<SearchMoviesEvent, SearchMoviesState> transition) {
    print(transition);
    super.onTransition(transition);
  }

  @override
  Stream<SearchMoviesState> mapEventToState(
    SearchMoviesEvent event,
  ) async* {
    if (event is TextChangedEvent) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchMoviesStateEmpty();
      } else {
        yield SearchMoviesStateLoading();
        try {
          final results = await searchMoviesRepository.search(searchTerm);
          yield SearchMoviesStateSuccess(movies: results.items);
        } catch (error) {
          yield SearchMoviesStateError(error: error);
        }
      }
    }
  }
}
