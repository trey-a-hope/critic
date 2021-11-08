part of 'create_recommendation_bloc.dart';

abstract class CreateRecommendationState extends Equatable {
  const CreateRecommendationState();

  @override
  List<Object?> get props => [];
}

class CreateRecommendationInitial extends CreateRecommendationState {}

class LoadingState extends CreateRecommendationState {}

class LoadedState extends CreateRecommendationState {
  final MovieModel? selectedMovie;
  final UserModel? selectedUser;

  LoadedState({
    required this.selectedMovie,
    required this.selectedUser,
  });

  @override
  List<Object?> get props => [
        selectedMovie,
        selectedUser,
      ];
}

class SuccessState extends CreateRecommendationState {}

class ErrorState extends CreateRecommendationState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
