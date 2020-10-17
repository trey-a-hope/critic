import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CommentsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CommentsEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class DeleteCommentEvent extends CommentsEvent {
  final String commentID;

  DeleteCommentEvent({
    @required this.commentID,
  });

  List<Object> get props => [
        commentID,
      ];
}

class ReportCommentEvent extends CommentsEvent {
  final String commentID;

  ReportCommentEvent({
    @required this.commentID,
  });

  List<Object> get props => [
        commentID,
      ];
}
