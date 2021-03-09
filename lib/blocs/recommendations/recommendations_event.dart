part of 'recommendations_bloc.dart';

class RecommendationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends RecommendationsEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class RecommendationsUpdatedEvent extends RecommendationsEvent {
  final List<RecommendationModel> recommendations;

  RecommendationsUpdatedEvent({
    @required this.recommendations,
  });

  @override
  List<Object> get props => [
        recommendations,
      ];
}

class DeleteRecommendationEvent extends RecommendationsEvent {
  final String recommendationID;

  DeleteRecommendationEvent({
    @required this.recommendationID,
  });

  @override
  List<Object> get props => [
        recommendationID,
      ];
}
