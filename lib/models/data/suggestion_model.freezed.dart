// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) {
  return _SuggestionModel.fromJson(json);
}

/// @nodoc
class _$SuggestionModelTearOff {
  const _$SuggestionModelTearOff();

  _SuggestionModel call(
      {String? id,
      required String message,
      required String uid,
      required DateTime created}) {
    return _SuggestionModel(
      id: id,
      message: message,
      uid: uid,
      created: created,
    );
  }

  SuggestionModel fromJson(Map<String, Object?> json) {
    return SuggestionModel.fromJson(json);
  }
}

/// @nodoc
const $SuggestionModel = _$SuggestionModelTearOff();

/// @nodoc
mixin _$SuggestionModel {
  /// The unique id of the suggestion.
  String? get id => throw _privateConstructorUsedError;

  /// The message.
  String get message => throw _privateConstructorUsedError;

  /// User id of the person who sent the suggestion.
  String get uid => throw _privateConstructorUsedError;

  /// Date it was created.
  DateTime get created => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestionModelCopyWith<SuggestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionModelCopyWith<$Res> {
  factory $SuggestionModelCopyWith(
          SuggestionModel value, $Res Function(SuggestionModel) then) =
      _$SuggestionModelCopyWithImpl<$Res>;
  $Res call({String? id, String message, String uid, DateTime created});
}

/// @nodoc
class _$SuggestionModelCopyWithImpl<$Res>
    implements $SuggestionModelCopyWith<$Res> {
  _$SuggestionModelCopyWithImpl(this._value, this._then);

  final SuggestionModel _value;
  // ignore: unused_field
  final $Res Function(SuggestionModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? uid = freezed,
    Object? created = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
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
abstract class _$SuggestionModelCopyWith<$Res>
    implements $SuggestionModelCopyWith<$Res> {
  factory _$SuggestionModelCopyWith(
          _SuggestionModel value, $Res Function(_SuggestionModel) then) =
      __$SuggestionModelCopyWithImpl<$Res>;
  @override
  $Res call({String? id, String message, String uid, DateTime created});
}

/// @nodoc
class __$SuggestionModelCopyWithImpl<$Res>
    extends _$SuggestionModelCopyWithImpl<$Res>
    implements _$SuggestionModelCopyWith<$Res> {
  __$SuggestionModelCopyWithImpl(
      _SuggestionModel _value, $Res Function(_SuggestionModel) _then)
      : super(_value, (v) => _then(v as _SuggestionModel));

  @override
  _SuggestionModel get _value => super._value as _SuggestionModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? uid = freezed,
    Object? created = freezed,
  }) {
    return _then(_SuggestionModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
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
class _$_SuggestionModel implements _SuggestionModel {
  _$_SuggestionModel(
      {this.id,
      required this.message,
      required this.uid,
      required this.created});

  factory _$_SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$$_SuggestionModelFromJson(json);

  @override

  /// The unique id of the suggestion.
  final String? id;
  @override

  /// The message.
  final String message;
  @override

  /// User id of the person who sent the suggestion.
  final String uid;
  @override

  /// Date it was created.
  final DateTime created;

  @override
  String toString() {
    return 'SuggestionModel(id: $id, message: $message, uid: $uid, created: $created)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SuggestionModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.created, created) || other.created == created));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, message, uid, created);

  @JsonKey(ignore: true)
  @override
  _$SuggestionModelCopyWith<_SuggestionModel> get copyWith =>
      __$SuggestionModelCopyWithImpl<_SuggestionModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SuggestionModelToJson(this);
  }
}

abstract class _SuggestionModel implements SuggestionModel {
  factory _SuggestionModel(
      {String? id,
      required String message,
      required String uid,
      required DateTime created}) = _$_SuggestionModel;

  factory _SuggestionModel.fromJson(Map<String, dynamic> json) =
      _$_SuggestionModel.fromJson;

  @override

  /// The unique id of the suggestion.
  String? get id;
  @override

  /// The message.
  String get message;
  @override

  /// User id of the person who sent the suggestion.
  String get uid;
  @override

  /// Date it was created.
  DateTime get created;
  @override
  @JsonKey(ignore: true)
  _$SuggestionModelCopyWith<_SuggestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}
