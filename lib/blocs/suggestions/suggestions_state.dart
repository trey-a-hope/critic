part of 'suggestions_bloc.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object> get props => [];
}

class SuggestionsInitial extends SuggestionsState {}

class SuggestionsLoading extends SuggestionsState {}

class SuggestionsSuccess extends SuggestionsState {}

class ErrorState extends SuggestionsState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
