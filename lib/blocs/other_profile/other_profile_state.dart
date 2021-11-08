part of 'other_profile_bloc.dart';

class OtherProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends OtherProfileState {}

class LoadingState extends OtherProfileState {}

class LoadedState extends OtherProfileState {
  final UserModel otherUser;
  final UserModel currentUser;

  LoadedState({
    required this.otherUser,
    required this.currentUser,
  });

  @override
  List<Object> get props => [
        otherUser,
        currentUser,
      ];
}

class ErrorState extends OtherProfileState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
