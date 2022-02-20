import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:get_storage/get_storage.dart';
import 'movie_service.dart';

class WatchlistService extends GetxService {
  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Users database collection reference.
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');

  /// Instantiate movie service.
  final MovieService _movieService = Get.find();

  Future<void> addMovieToWatchList({
    required String imdbID,
  }) async {
    try {
      /// Get uid of current user.
      final String uid = _getStorage.read('uid');

      /// Get the document reference for this user.
      final DocumentReference userDocRef = _usersDB.doc(uid);

      /// Add the movie id to the users watch list.
      await userDocRef.update({
        'watchList': FieldValue.arrayUnion([imdbID])
      });
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> removeMovieFromWatchList({
    required String imdbID,
  }) async {
    try {
      /// Get uid of current user.
      final String uid = _getStorage.read('uid');

      /// Get the document reference for this user.
      final DocumentReference userDocRef = _usersDB.doc(uid);

      /// Remove the movie id to the users watch list.
      await userDocRef.update({
        'watchList': FieldValue.arrayRemove([imdbID])
      });
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<bool> watchListHasMovie({
    required String imdbID,
  }) async {
    try {
      /// Get uid of current user.
      final String uid = _getStorage.read('uid');

      /// Get the document reference for this user.
      final DocumentReference userDocRef = _usersDB.doc(uid);

      /// Convert document reference to user model.
      UserModel user = (await (await userDocRef.get())
              .reference
              .withConverter<UserModel>(
                  fromFirestore: (snapshot, _) =>
                      UserModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .get())
          .data() as UserModel;

      /// Check to see if the movie id is in their list.
      if (user.watchList.contains(imdbID)) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<MovieModel>> listMoviesFromWatchList() async {
    try {
      /// Get uid of current user.
      final String uid = _getStorage.read('uid');

      /// Get the document reference for this user.
      final DocumentReference userDocRef = _usersDB.doc(uid);

      /// Convert document reference to user model.
      UserModel user = (await (await userDocRef.get())
              .reference
              .withConverter<UserModel>(
                  fromFirestore: (snapshot, _) =>
                      UserModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .get())
          .data() as UserModel;

      /// Fetch movie for each id in their watchlist array.
      List<MovieModel> movies = [];
      for (int i = 0; i < user.watchList.length; i++) {
        String imdb = user.watchList[i];
        MovieModel movie = await _movieService.getMovieByID(id: imdb);
        movies.add(movie);
      }

      return movies;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
