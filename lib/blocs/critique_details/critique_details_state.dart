part of 'critique_details_bloc.dart';

class CritiqueDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CritiqueDetailsState {}

class LoadedState extends CritiqueDetailsState {
  final UserModel currentUser;
  final UserModel critiqueUser;
  final CritiqueModel critiqueModel;
  final bool isLiked;
  final List<UserModel> likedUsers;
  final List<CritiqueModel> otherCritiques;
  final MovieModel movie;

  LoadedState({
    required this.currentUser,
    required this.critiqueUser,
    required this.critiqueModel,
    required this.isLiked,
    required this.likedUsers,
    required this.otherCritiques,
    required this.movie,
  });

  @override
  List<Object> get props => [
        currentUser,
        critiqueUser,
        critiqueModel,
        isLiked,
        likedUsers,
        otherCritiques,
        movie,
      ];
}

class ErrorState extends CritiqueDetailsState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
