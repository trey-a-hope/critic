import 'package:equatable/equatable.dart';

class PostCommentState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingState extends PostCommentState {}

class LoadedState extends PostCommentState {
  LoadedState();

  @override
  List<Object> get props => [];
}
