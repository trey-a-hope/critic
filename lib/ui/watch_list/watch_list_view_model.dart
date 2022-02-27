import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/watchlist_service.dart';
import 'package:get/get.dart';

class WatchListViewModel extends GetxController {
  /// Movies in watchlist.
  List<MovieModel> movies = [];

  /// Instantiate watchlist service.
  final WatchlistService _watchlistService = Get.find();

  /// Indicator that the page is loading.
  bool _isLoading = true;

  @override
  void onInit() async {
    // Fetch movies in watchlist.
    movies = await _watchlistService.listMoviesFromWatchList();

    // Turn off loading indicator.
    _isLoading = false;

    update();

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  bool get isLoading => _isLoading;

  /// Fetch movies in watchlist.
  void refreshList() async {
    movies = await _watchlistService.listMoviesFromWatchList();

    update();
  }
}
