part of 'create_recommendation_bloc.dart';

abstract class CreateRecommendationEvent extends Equatable {
  const CreateRecommendationEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CreateRecommendationEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class SubmitRecommendationEvent extends CreateRecommendationEvent {
  final String message;

  SubmitRecommendationEvent({
    required this.message,
  });

  List<Object> get props => [
        message,
      ];
}

class UpdateSelectedMovieEvent extends CreateRecommendationEvent {
  final MovieModel movie;

  UpdateSelectedMovieEvent({required this.movie});

  List<Object> get props => [
        movie,
      ];
}

class UpdateSelectedUserEvent extends CreateRecommendationEvent {
  final UserModel user;

  UpdateSelectedUserEvent({required this.user});

  List<Object> get props => [
        user,
      ];
}
