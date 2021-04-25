part of 'web_bloc.dart';

class WebState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends WebState {}

class LoadedState extends WebState {
  final List<UserModel> topFiveRecentUsers;
  final List<UserModel> topFiveCritiquesUsers;

  LoadedState({
    @required this.topFiveRecentUsers,
    @required this.topFiveCritiquesUsers,
  });

  @override
  List<Object> get props => [
        topFiveRecentUsers,
        topFiveCritiquesUsers,
      ];
}

class ErrorState extends WebState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
