part of 'explore_bloc.dart';

class ExploreState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends ExploreState {}

class LoadedState extends ExploreState {
  final UserModel currentUser;
  final int pageFetchLimit;

  LoadedState({
    @required this.currentUser,
    @required this.pageFetchLimit,
  });

  @override
  List<Object> get props => [
        currentUser,
        pageFetchLimit,
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
