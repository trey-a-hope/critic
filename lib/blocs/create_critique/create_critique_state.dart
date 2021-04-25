part of 'create_critique_bloc.dart';

class CreateCritiqueState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends CreateCritiqueState {}

class LoadedState extends CreateCritiqueState {
  final MovieModel movie;
  final bool watchListHasMovie;
  final UserModel currentUser;
  final List<CritiqueModel> otherCritiques;

  LoadedState({
    @required this.movie,
    @required this.watchListHasMovie,
    @required this.currentUser,
    @required this.otherCritiques,
  });

  @override
  List<Object> get props => [
        movie,
        watchListHasMovie,
        currentUser,
        otherCritiques,
      ];
}
