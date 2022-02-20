import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/watchlist_service.dart';
import 'package:get/get.dart';

class WatchListViewModel extends GetxController {
  /// Movies in watchlist.
  List<MovieModel> movies = [];

  /// Instantiate watchlist service.
  final WatchlistService _watchlistService = Get.find();

  @override
  void onInit() async {
    /// Fetch movies in watchlist.
    movies = await _watchlistService.listMoviesFromWatchList();

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

  void refreshList() async {
    /// Fetch movies in watchlist.
    movies = await _watchlistService.listMoviesFromWatchList();

    update();
  }
}
