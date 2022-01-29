import 'package:critic/models/movie_model.dart';
import 'package:critic/models/recommendation_model.dart';
import 'package:critic/models/user_model.dart';

class RecommendationTuple {
  final RecommendationModel recommendation;
  final UserModel user;
  final MovieModel movie;

  const RecommendationTuple({
    required this.recommendation,
    required this.user,
    required this.movie,
  });
}
