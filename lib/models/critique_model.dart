import 'package:critic/models/comment_model.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';
import 'package:critic/services/movie_service.dart';
import 'package:critic/services/user_service.dart';
import '../service_locator.dart';

class CritiqueModel {
  CritiqueModel({
    required this.id,
    required this.message,
    required this.imdbID,
    required this.uid,
    required this.comments,
    required this.created,
    required this.modified,
    required this.rating,
    required this.likes,
    required this.genres,
  });

  factory CritiqueModel.fromJSON({required Map map}) {
    return CritiqueModel(
      id: map['_id'],
      message: map['message'],
      imdbID: map['imdbID'],
      uid: map['uid'],
      comments: List.from((map['comments'] as List<dynamic>).map((element) {
        return CommentModel.fromJSON(map: element);
      }).toList()),
      created: DateTime.parse(map['created']),
      modified: DateTime.parse(map['modified']),
      rating: map['rating'].toDouble(),
      likes: List.from(map['likes']),
      genres: List.from(map['genres']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'imdbID': imdbID,
      'uid': uid,
      'rating': rating,
      'genres': genres,
      'created': created.toIso8601String(),
      'modified': modified.toIso8601String(),
    };
  }

  //Return the user associated with this critique.
  Future<UserModel> user() async {
    return await locator<UserService>().retrieveUser(uid: uid);
  }

  /// Movie associated with this critique.
  MovieModel? movie;

  //Return the movie associated with this critique.
  Future<MovieModel> getMovie() async {
    return await locator<MovieService>().getMovieByID(id: imdbID);
  }

  /// Id of the critique
  String? id;

  /// The review of the movie
  String message;

  /// Movie Id
  String imdbID;

  /// User Id associated with this critique
  String uid;

  /// Comments
  List<CommentModel> comments;

  /// Time this was posted
  DateTime created;

  /// Time this was modified
  DateTime modified;

  /// Rating of movie
  double rating;

  /// Users who liked the critique
  List<String> likes;

  /// Genres the movie belongs to
  List<String> genres;
}
