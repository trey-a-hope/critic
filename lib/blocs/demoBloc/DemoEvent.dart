import 'package:equatable/equatable.dart';

class DemoEvent extends Equatable {
  const DemoEvent();
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends DemoEvent {
  LoadPageEvent();

  List<Object> get props => [];
}
