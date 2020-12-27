part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {}

class LoadedState extends ProfileState {
  final UserModel currentUser;
  final int followerCount;
  final int followingCount;

  LoadedState({
    @required this.currentUser,
    @required this.followerCount,
    @required this.followingCount,
  });

  @override
  List<Object> get props => [
        currentUser,
        followerCount,
        followingCount,
      ];
}

class ErrorState extends ProfileState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
