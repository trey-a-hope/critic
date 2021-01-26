part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final UserModel currentUser;
  final List<UserModel> mostRecentUsers;
  final List<MovieModel> popularMovies;
  final int critiqueCount;
  final int userCount;

  const HomeLoadedState({
    @required this.currentUser,
    @required this.mostRecentUsers,
    @required this.popularMovies,
    @required this.critiqueCount,
    @required this.userCount,
  });

  @override
  List<Object> get props => [
        currentUser,
        mostRecentUsers,
        popularMovies,
        critiqueCount,
        userCount,
      ];
}
