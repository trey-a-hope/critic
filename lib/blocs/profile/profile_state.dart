part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {}

class LoadedState extends ProfileState {
  final UserModel currentUser;

  LoadedState({
    required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
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
