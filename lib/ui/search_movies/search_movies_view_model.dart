import 'dart:async';

import 'package:critic/models/data/search_movies_result_item_model.dart';
import 'package:critic/ui/search_movies/search_movies_cache.dart';
import 'package:critic/ui/search_movies/search_movies_repository.dart';
import 'package:critic/ui/search_movies/search_movies_result.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SearchMoviesViewModel extends GetxController {
  /// Movie results.
  List<SearchMoviesResultItemModel> movies = [];

  /// Repository for performing movie search.
  final SearchMoviesRepository searchMoviesRepository = SearchMoviesRepository(
    cache: SearchMoviesCache(),
  );

  /// Debouncer for preventing search firing multiple times.
  Timer? _debounce;

  /// Deterimines if loading indicator is present.
  bool isLoading = false;

  /// Error message when searching.
  String? errorMessage;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    _debounce?.cancel();
    super.onClose();
  }

  void udpateSearchText({required String text}) async {
    /// Display loading indicator.
    isLoading = true;

    /// Clear error message.
    errorMessage = null;

    update();

    /// Cancel debouncer if it's active.
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    /// Set new debouncer value.
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (text.isEmpty) {
        /// Return empty array of results.
        movies = [];

        /// Clear loading indicator.
        isLoading = false;

        update();
      } else {
        try {
          /// Attempt to search for movies.
          final SearchMoviesResult results =
              await searchMoviesRepository.search(text);

          /// Extract movies from result.
          movies = results.items;

          /// Clear loading indicator.
          isLoading = false;

          update();
        } catch (e) {
          /// Set error message.
          errorMessage = e.toString();

          /// Clear loading indicator.
          isLoading = false;

          update();
        }
      }
    });
  }
}
