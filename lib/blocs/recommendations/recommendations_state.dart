part of 'recommendations_bloc.dart';

class RecommendationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends RecommendationsState {}

class LoadingState extends RecommendationsState {}

class LoadedState extends RecommendationsState {
  final List<RecommendationModel> recommendations;

  LoadedState({
    required this.recommendations,
  });

  @override
  List<Object> get props => [
        recommendations,
      ];
}

class EmptyRecommendationsState extends RecommendationsState {}
