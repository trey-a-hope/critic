part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {}

class LoadedState extends ProfileState {
  final UserModel currentUser;
  final List<MovieModel> movies;

  LoadedState({
    required this.currentUser,
    required this.movies,
  });

  @override
  List<Object> get props => [
        currentUser,
        movies,
      ];
}

class ErrorState extends ProfileState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
