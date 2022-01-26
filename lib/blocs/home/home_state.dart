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
  final List<UserModel> recentlyActiveUsers;
  final List<CritiqueModel> mostRecentCritiques;
  final int userCount;

  const HomeLoadedState({
    required this.currentUser,
    required this.recentlyActiveUsers,
    required this.mostRecentCritiques,
    required this.userCount,
  });

  @override
  List<Object> get props => [
        currentUser,
        recentlyActiveUsers,
        mostRecentCritiques,
        userCount,
      ];
}

class ErrorState extends HomeState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
