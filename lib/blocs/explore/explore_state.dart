part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExploreState {}

class LoadedState extends ExploreState {
  final UserModel currentUser;

  LoadedState({
    @required this.currentUser,
  });

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends ExploreState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
