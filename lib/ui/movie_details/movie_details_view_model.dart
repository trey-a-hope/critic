import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/watchlist_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MovieDetailsViewModel extends GetxController {
  /// The id of the movie.
  final MovieModel movie = Get.arguments['movie'];

  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate watchlist service.
  final WatchlistService _watchlistService = Get.find();

  /// All critiques related to this movie.
  List<CritiqueModel> critiques = [];

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Determines if this movie is in the users watchlist or not.
  bool movieInWatchlist = false;

  /// Indicator if page is still loading.
  bool _isLoading = true;

  @override
  void onInit() async {
    /// Fetch all critiques for this movie.
    critiques = await _critiqueService.list(
      limit: 100,
      imdbID: movie.imdbID,
    ); //TODO: Decrease limit once pagination is needed on this page.

    // Place current user's critique at front if this applies.
    int index = critiques
        .indexWhere((critique) => critique.uid == _getStorage.read('uid'));
    if (index > 0) {
      // Remove critique at that index.
      CritiqueModel myCritique = critiques.removeAt(index);

      // Insert it to the front.
      critiques.insert(0, myCritique);
    }

    /// Check if movie in watchlist.
    movieInWatchlist =
        await _watchlistService.watchListHasMovie(imdbID: movie.imdbID);

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
