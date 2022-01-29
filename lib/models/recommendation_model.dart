import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';

import '../service_locator.dart';

class RecommendationModel {
  RecommendationModel({
    required this.id,
    required this.message,
    required this.imdbID,
    required this.uid,
    required this.created,
  });

  factory RecommendationModel.fromDoc({required DocumentSnapshot data}) {
    return RecommendationModel(
      id: data['id'],
      message: data['message'],
      imdbID: data['imdbID'],
      uid: data['uid'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'imdbID': imdbID,
      'uid': uid,
      'created': created,
    };
  }

  /// User who sent the recommendation.
  UserModel? user;

  /// Fetch the user who sent the recommendation.
  Future<void> getUser() async {
    user = await locator<UserService>().retrieveUser(uid: uid);
  }

  /// The movie that the user is recommending.
  MovieModel? movie;

  /// Fetch the movie the user is recommending.
  Future<void> getMovie() async {
    movie = await locator<MovieService>().getMovieByID(id: imdbID);
  }

  /// The id of the recommendation.
  String? id;

  /// Message the user sent.
  String message;

  /// Id of the movie.
  String imdbID;

  /// Id of the user.
  String uid;

  /// Date this recommendation was created.
  DateTime created;
}
