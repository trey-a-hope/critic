part of 'create_critique_bloc.dart';

abstract class CreateCritiqueEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CreateCritiqueEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class SubmitEvent extends CreateCritiqueEvent {
  final String critique;
  final double rating;

  SubmitEvent({
    required this.critique,
    required this.rating,
  });

  List<Object> get props => [
        critique,
        rating,
      ];
}

class AddMovieToWatchlistEvent extends CreateCritiqueEvent {
  AddMovieToWatchlistEvent();

  List<Object> get props => [];
}

class RemoveMovieFromWatchlistEvent extends CreateCritiqueEvent {
  RemoveMovieFromWatchlistEvent();

  List<Object> get props => [];
}
