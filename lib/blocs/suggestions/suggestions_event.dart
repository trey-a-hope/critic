part of 'suggestions_bloc.dart';

abstract class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends SuggestionsEvent {}

class SubmitEvent extends SuggestionsEvent {
  final String message;

  SubmitEvent({
    @required this.message,
  });

  List<Object> get props => [
        message,
      ];
}
