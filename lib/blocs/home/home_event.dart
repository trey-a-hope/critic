part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends HomeEvent {
  LoadPageEvent();

  List<Object> get props => [];
}