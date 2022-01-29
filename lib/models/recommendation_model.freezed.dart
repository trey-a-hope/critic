// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'recommendation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RecommendationModel _$RecommendationModelFromJson(Map<String, dynamic> json) {
  return _RecommendationModel.fromJson(json);
}

/// @nodoc
class _$RecommendationModelTearOff {
  const _$RecommendationModelTearOff();

  _RecommendationModel call(
      {required String id,
      required String message,
      required String imdbID,
      required String uid,
      @TimestampConverter() required DateTime created}) {
    return _RecommendationModel(
      id: id,
      message: message,
      imdbID: imdbID,
      uid: uid,
      created: created,
    );
  }

  RecommendationModel fromJson(Map<String, Object?> json) {
    return RecommendationModel.fromJson(json);
  }
}

/// @nodoc
const $RecommendationModel = _$RecommendationModelTearOff();

/// @nodoc
mixin _$RecommendationModel {
  /// The unique id of the recommendation.
  String get id => throw _privateConstructorUsedError;

  /// The message.
  String get message => throw _privateConstructorUsedError;

  /// Movie id associated with the recommendation.
  String get imdbID => throw _privateConstructorUsedError;

  /// User id of the person who sent the recommendation.
  String get uid => throw _privateConstructorUsedError;

  /// Date it was created.
  @TimestampConverter()
  DateTime get created => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecommendationModelCopyWith<RecommendationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationModelCopyWith<$Res> {
  factory $RecommendationModelCopyWith(
          RecommendationModel value, $Res Function(RecommendationModel) then) =
      _$RecommendationModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String message,
      String imdbID,
      String uid,
      @TimestampConverter() DateTime created});
}

/// @nodoc
class _$RecommendationModelCopyWithImpl<$Res>
    implements $RecommendationModelCopyWith<$Res> {
  _$RecommendationModelCopyWithImpl(this._value, this._then);

  final RecommendationModel _value;
  // ignore: unused_field
  final $Res Function(RecommendationModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? imdbID = freezed,
    Object? uid = freezed,
    Object? created = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imdbID: imdbID == freezed
          ? _value.imdbID
          : imdbID // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$RecommendationModelCopyWith<$Res>
    implements $RecommendationModelCopyWith<$Res> {
  factory _$RecommendationModelCopyWith(_RecommendationModel value,
          $Res Function(_RecommendationModel) then) =
      __$RecommendationModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String message,
      String imdbID,
      String uid,
      @TimestampConverter() DateTime created});
}

/// @nodoc
class __$RecommendationModelCopyWithImpl<$Res>
    extends _$RecommendationModelCopyWithImpl<$Res>
    implements _$RecommendationModelCopyWith<$Res> {
  __$RecommendationModelCopyWithImpl(
      _RecommendationModel _value, $Res Function(_RecommendationModel) _then)
      : super(_value, (v) => _then(v as _RecommendationModel));

  @override
  _RecommendationModel get _value => super._value as _RecommendationModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? imdbID = freezed,
    Object? uid = freezed,
    Object? created = freezed,
  }) {
    return _then(_RecommendationModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      imdbID: imdbID == freezed
          ? _value.imdbID
          : imdbID // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      created: created == freezed
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RecommendationModel
    with DiagnosticableTreeMixin
    implements _RecommendationModel {
  _$_RecommendationModel(
      {required this.id,
      required this.message,
      required this.imdbID,
      required this.uid,
      @TimestampConverter() required this.created});

  factory _$_RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$$_RecommendationModelFromJson(json);

  @override

  /// The unique id of the recommendation.
  final String id;
  @override

  /// The message.
  final String message;
  @override

  /// Movie id associated with the recommendation.
  final String imdbID;
  @override

  /// User id of the person who sent the recommendation.
  final String uid;
  @override

  /// Date it was created.
  @TimestampConverter()
  final DateTime created;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RecommendationModel(id: $id, message: $message, imdbID: $imdbID, uid: $uid, created: $created)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RecommendationModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('imdbID', imdbID))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('created', created));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecommendationModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imdbID, imdbID) || other.imdbID == imdbID) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.created, created) || other.created == created));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, message, imdbID, uid, created);

  @JsonKey(ignore: true)
  @override
  _$RecommendationModelCopyWith<_RecommendationModel> get copyWith =>
      __$RecommendationModelCopyWithImpl<_RecommendationModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecommendationModelToJson(this);
  }
}

abstract class _RecommendationModel implements RecommendationModel {
  factory _RecommendationModel(
          {required String id,
          required String message,
          required String imdbID,
          required String uid,
          @TimestampConverter() required DateTime created}) =
      _$_RecommendationModel;

  factory _RecommendationModel.fromJson(Map<String, dynamic> json) =
      _$_RecommendationModel.fromJson;

  @override

  /// The unique id of the recommendation.
  String get id;
  @override

  /// The message.
  String get message;
  @override

  /// Movie id associated with the recommendation.
  String get imdbID;
  @override

  /// User id of the person who sent the recommendation.
  String get uid;
  @override

  /// Date it was created.
  @TimestampConverter()
  DateTime get created;
  @override
  @JsonKey(ignore: true)
  _$RecommendationModelCopyWith<_RecommendationModel> get copyWith =>
      throw _privateConstructorUsedError;
}
