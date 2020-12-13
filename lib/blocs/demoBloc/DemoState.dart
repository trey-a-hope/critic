import 'package:equatable/equatable.dart';

class DemoState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends DemoState {}

class LoadedState extends DemoState {
  LoadedState();

  @override
  List<Object> get props => [];
}
