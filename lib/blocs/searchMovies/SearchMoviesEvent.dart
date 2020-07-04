import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();
}

class TextChangedEvent extends SearchMoviesEvent {
  final String text;

  const TextChangedEvent({@required this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
