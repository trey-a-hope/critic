import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:critic/converters/timestamp_converter.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    /// The unique id of the user.
    required String uid,

    /// The user's email.
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

    /// Ids of movies in watch list.
    required List<String> watchList,

    /// Ids of users that this user has blocked.
    required List<String> blockedUsers,

    /// Ids of users that this user is following.
    required List<String> followings,

    /// Ids of users that are following this user.
    required List<String> followers,

    /// Determines if the user is active in the app or not.
    required bool isOnline,

    /// Show user google ads if flag is true.
    required bool showAds,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs
