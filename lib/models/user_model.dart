import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:critic/converters/timestamp_converter.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    /// The unique id of the user.
    String? uid,

    /// The users email.
    required String email,

    /// User's image url.
    required String imgUrl,

    /// Firebase Cloud Message token for push notifications.
    String? fcmToken,

    /// Time the user was last modified.
    @TimestampConverter() required DateTime modified,

    /// Time the user was created.
    @TimestampConverter() required DateTime created,

    /// Username of the user.
    required String username,

    /// Number of critiques.
    required int critiqueCount,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
