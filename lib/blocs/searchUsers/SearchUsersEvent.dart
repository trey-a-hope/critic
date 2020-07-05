import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SearchUsersEvent extends Equatable {
  const SearchUsersEvent();
}

class TextChangedEvent extends SearchUsersEvent {
  final String text;

  const TextChangedEvent({@required this.text});

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
