import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PostCommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends PostCommentEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class SubmitEvent extends PostCommentEvent {
  final String message;

  SubmitEvent({
    @required this.message,
  });

  List<Object> get props => [
        message,
      ];
}
