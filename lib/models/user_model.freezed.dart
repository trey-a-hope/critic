// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
class _$UserModelTearOff {
  const _$UserModelTearOff();

  _UserModel call(
      {String? uid,
      required String email,
      required String imgUrl,
      String? fcmToken,
      @TimestampConverter() required DateTime modified,
      @TimestampConverter() required DateTime created,
      required String username,
      required int critiqueCount}) {
    return _UserModel(
      uid: uid,
      email: email,
      imgUrl: imgUrl,
      fcmToken: fcmToken,
      modified: modified,
      created: created,
      username: username,
      critiqueCount: critiqueCount,
    );
  }

  UserModel fromJson(Map<String, Object?> json) {
    return UserModel.fromJson(json);
  }
}

/// @nodoc
const $UserModel = _$UserModelTearOff();

/// @nodoc
mixin _$UserModel {
  /// The unique id of the user.
  String? get uid => throw _privateConstructorUsedError;

  /// The users email.
  String get email => throw _privateConstructorUsedError;

  /// User's image url.
  String get imgUrl => throw _privateConstructorUsedError;

  /// Firebase Cloud Message token for push notifications.
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Time the user was last modified.
  @TimestampConverter()
  DateTime get modified => throw _privateConstructorUsedError;

  /// Time the user was created.
  @TimestampConverter()
  DateTime get created => throw _privateConstructorUsedError;

  /// Username of the user.
  String get username => throw _privateConstructorUsedError;

  /// Number of critiques.
  int get critiqueCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res>;
  $Res call(
      {String? uid,
      String email,
      String imgUrl,
      String? fcmToken,
      @TimestampConverter() DateTime modified,
      @TimestampConverter() DateTime created,
      String username,
      int critiqueCount});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  final UserModel _value;
  // ignore: unused_field
  final $Res Function(UserModel) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? email = freezed,
    Object? imgUrl = freezed,
    Object? fcmToken = freezed,
    Object? modified = freezed,
    Object? created = freezed,
    Object? username = freezed,
    Object? critiqueCount = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      imgUrl: imgUrl == freezed
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      modified: modified == freezed
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      critiqueCount: critiqueCount == freezed
          ? _value.critiqueCount
          : critiqueCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) then) =
      __$UserModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? uid,
      String email,
      String imgUrl,
      String? fcmToken,
      @TimestampConverter() DateTime modified,
      @TimestampConverter() DateTime created,
      String username,
      int critiqueCount});
}

/// @nodoc
class __$UserModelCopyWithImpl<$Res> extends _$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(_UserModel _value, $Res Function(_UserModel) _then)
      : super(_value, (v) => _then(v as _UserModel));

  @override
  _UserModel get _value => super._value as _UserModel;

  @override
  $Res call({
    Object? uid = freezed,
    Object? email = freezed,
    Object? imgUrl = freezed,
    Object? fcmToken = freezed,
    Object? modified = freezed,
    Object? created = freezed,
    Object? username = freezed,
    Object? critiqueCount = freezed,
  }) {
    return _then(_UserModel(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      imgUrl: imgUrl == freezed
          ? _value.imgUrl
          : imgUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      modified: modified == freezed
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      critiqueCount: critiqueCount == freezed
          ? _value.critiqueCount
          : critiqueCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserModel with DiagnosticableTreeMixin implements _UserModel {
  _$_UserModel(
      {this.uid,
      required this.email,
      required this.imgUrl,
      this.fcmToken,
      @TimestampConverter() required this.modified,
      @TimestampConverter() required this.created,
      required this.username,
      required this.critiqueCount});

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$$_UserModelFromJson(json);

  @override

  /// The unique id of the user.
  final String? uid;
  @override

  /// The users email.
  final String email;
  @override

  /// User's image url.
  final String imgUrl;
  @override

  /// Firebase Cloud Message token for push notifications.
  final String? fcmToken;
  @override

  /// Time the user was last modified.
  @TimestampConverter()
  final DateTime modified;
  @override

  /// Time the user was created.
  @TimestampConverter()
  final DateTime created;
  @override

  /// Username of the user.
  final String username;
  @override

  /// Number of critiques.
  final int critiqueCount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(uid: $uid, email: $email, imgUrl: $imgUrl, fcmToken: $fcmToken, modified: $modified, created: $created, username: $username, critiqueCount: $critiqueCount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('imgUrl', imgUrl))
      ..add(DiagnosticsProperty('fcmToken', fcmToken))
      ..add(DiagnosticsProperty('modified', modified))
      ..add(DiagnosticsProperty('created', created))
      ..add(DiagnosticsProperty('username', username))
      ..add(DiagnosticsProperty('critiqueCount', critiqueCount));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserModel &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.imgUrl, imgUrl) || other.imgUrl == imgUrl) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.critiqueCount, critiqueCount) ||
                other.critiqueCount == critiqueCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, email, imgUrl, fcmToken,
      modified, created, username, critiqueCount);

  @JsonKey(ignore: true)
  @override
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserModelToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  factory _UserModel(
      {String? uid,
      required String email,
      required String imgUrl,
      String? fcmToken,
      @TimestampConverter() required DateTime modified,
      @TimestampConverter() required DateTime created,
      required String username,
      required int critiqueCount}) = _$_UserModel;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override

  /// The unique id of the user.
  String? get uid;
  @override

  /// The users email.
  String get email;
  @override

  /// User's image url.
  String get imgUrl;
  @override

  /// Firebase Cloud Message token for push notifications.
  String? get fcmToken;
  @override

  /// Time the user was last modified.
  @TimestampConverter()
  DateTime get modified;
  @override

  /// Time the user was created.
  @TimestampConverter()
  DateTime get created;
  @override

  /// Username of the user.
  String get username;
  @override

  /// Number of critiques.
  int get critiqueCount;
  @override
  @JsonKey(ignore: true)
  _$UserModelCopyWith<_UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}
