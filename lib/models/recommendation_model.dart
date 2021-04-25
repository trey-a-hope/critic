import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_Model.dart';
import 'package:flutter/material.dart';

class RecommendationModel {
  String id;
  String message;
  String imdbID;
  String senderUID;
  DateTime created;

  UserModel sender;
  MovieModel movie;

  RecommendationModel({
    @required this.id,
    @required this.message,
    @required this.imdbID,
    @required this.senderUID,
    @required this.created,
  });

  factory RecommendationModel.fromDoc({@required DocumentSnapshot ds}) {
    final Map<String, dynamic> data = ds.data();
    return RecommendationModel(
      id: data['id'],
      message: data['message'],
      imdbID: data['imdbID'],
      senderUID: data['senderUID'],
      created: data['created'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'imdbID': imdbID,
      'senderUID': senderUID,
      'created': created,
    };
  }
}
