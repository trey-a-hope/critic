import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/watchlist_service.dart';
import 'package:get/get.dart';

class MovieDetailsViewModel extends GetxController {
  /// The id of the movie.
  final MovieModel movie = Get.arguments['movie'];

  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate watchlist service.
  final WatchlistService _watchlistService = Get.find();

  /// All critqiues related to this movie.
  List<CritiqueModel> critiques = [];

  /// Determines if this movie is in the users watchlist or not.
  bool movieInWatchlist = false;

  @override
  void onInit() async {
    /// Fetch all critiques for this movie.
    critiques = await _critiqueService.list(
      limit: 100,
      imdbID: movie.imdbID,
    ); //TODO: Decrease limit once pagination is needed on this page.

    /// Check if movie in watchlist.
    movieInWatchlist =
        await _watchlistService.watchListHasMovie(imdbID: movie.imdbID);

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

  Future<void> addMovieToWatchList() async {
    await _watchlistService.addMovieToWatchList(imdbID: movie.imdbID);
    movieInWatchlist =
        await _watchlistService.watchListHasMovie(imdbID: movie.imdbID);
    update();
  }

  Future<void> removeMovieFromWatchList() async {
    await _watchlistService.removeMovieFromWatchList(imdbID: movie.imdbID);
    movieInWatchlist =
        await _watchlistService.watchListHasMovie(imdbID: movie.imdbID);
    update();
    return;
  }
}
