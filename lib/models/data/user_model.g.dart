// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      uid: json['uid'] as String?,
      email: json['email'] as String,
      imgUrl: json['imgUrl'] as String,
      fcmToken: json['fcmToken'] as String?,
      modified:
          const TimestampConverter().fromJson(json['modified'] as Timestamp),
      created:
          const TimestampConverter().fromJson(json['created'] as Timestamp),
      username: json['username'] as String,
      critiqueCount: json['critiqueCount'] as int,
      watchList: (json['watchList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isOnline: json['isOnline'] as bool?,
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'imgUrl': instance.imgUrl,
      'fcmToken': instance.fcmToken,
      'modified': const TimestampConverter().toJson(instance.modified),
      'created': const TimestampConverter().toJson(instance.created),
      'username': instance.username,
      'critiqueCount': instance.critiqueCount,
      'watchList': instance.watchList,
      'isOnline': instance.isOnline,
    };
