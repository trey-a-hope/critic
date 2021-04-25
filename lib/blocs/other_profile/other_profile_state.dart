part of 'other_profile_bloc.dart';

class OtherProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends OtherProfileState {}

class LoadedState extends OtherProfileState {
  final UserModel otherUser;

  LoadedState({
    @required this.otherUser,
  });

  @override
  List<Object> get props => [
        otherUser,
      ];
}

class ErrorState extends OtherProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
