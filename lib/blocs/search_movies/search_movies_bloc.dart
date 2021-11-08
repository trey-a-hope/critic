import 'dart:async';
import 'package:critic/service_locator.dart';
import 'package:critic/services/movie_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/search_movies_result_item.dart';
import 'package:critic/widgets/Spinner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:critic/blocs/create_critique/create_critique_bloc.dart'
    as CREATE_CRITIQUE_BP;

part 'search_movies_cache.dart';
part 'search_movies_event.dart';
part 'search_movies_page.dart';
part 'search_movies_repository.dart';
part 'search_movies_result.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMoviesRepository searchMoviesRepository;
  SearchMoviesBloc({required this.searchMoviesRepository})
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
