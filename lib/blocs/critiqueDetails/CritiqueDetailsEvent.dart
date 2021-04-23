import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CritiqueDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CritiqueDetailsEvent {
  LoadPageEvent();

  List<Object> get props => [];
}

class DeleteCritiqueEvent extends CritiqueDetailsEvent {
  DeleteCritiqueEvent();

  List<Object> get props => [];
}

class ReportCritiqueEvent extends CritiqueDetailsEvent {
  ReportCritiqueEvent();

  List<Object> get props => [];
}

class LikeCritiqueEvent extends CritiqueDetailsEvent {
  LikeCritiqueEvent();

  List<Object> get props => [];
}

class UnlikeCritiqueEvent extends CritiqueDetailsEvent {
  UnlikeCritiqueEvent();

  List<Object> get props => [];
}

class PostCommentEvent extends CritiqueDetailsEvent {
  final String comment;

  PostCommentEvent({
    @required this.comment,
  });

  List<Object> get props => [
        comment,
      ];
}
