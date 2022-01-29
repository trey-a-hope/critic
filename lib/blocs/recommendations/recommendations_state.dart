part of 'recommendations_bloc.dart';

class RecommendationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends RecommendationsState {}

class LoadingState extends RecommendationsState {}

class LoadedState extends RecommendationsState {
  final List<RecommendationTuple> recommendationTuples;

  LoadedState({
    required this.recommendationTuples,
  });

  @override
  List<Object> get props => [
        recommendationTuples,
      ];
}

class EmptyRecommendationsState extends RecommendationsState {}
