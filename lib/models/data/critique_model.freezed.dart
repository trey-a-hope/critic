// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'critique_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CritiqueModel _$CritiqueModelFromJson(Map<String, dynamic> json) {
  return _CritiqueModel.fromJson(json);
}

/// @nodoc
class _$CritiqueModelTearOff {
  const _$CritiqueModelTearOff();

  _CritiqueModel call(
      {@JsonKey(name: '_id') String? id,
      required String message,
      required String imdbID,
      required String uid,
      required DateTime created,
      required DateTime modified,
      required double rating,
      required List<String> likes,
      required List<String> genres}) {
    return _CritiqueModel(
      id: id,
      message: message,
      imdbID: imdbID,
      uid: uid,
      created: created,
      modified: modified,
      rating: rating,
      likes: likes,
      genres: genres,
    );
  }

  CritiqueModel fromJson(Map<String, Object?> json) {
    return CritiqueModel.fromJson(json);
  }
}

/// @nodoc
const $CritiqueModel = _$CritiqueModelTearOff();

/// @nodoc
mixin _$CritiqueModel {
  /// Id of the critique
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;

  /// The review of the movie
  String get message => throw _privateConstructorUsedError;

  /// Movie Id
  String get imdbID => throw _privateConstructorUsedError;

  /// User Id associated with this critique
  String get uid => throw _privateConstructorUsedError;

  /// Comments
// required List<CommentModel> comments,TODO: Uncomment this after new UI of critique details page.
  /// Time this was posted
  DateTime get created => throw _privateConstructorUsedError;

  /// Time this was modified
  DateTime get modified => throw _privateConstructorUsedError;

  /// Rating of movie
  double get rating => throw _privateConstructorUsedError;

  /// Users who liked the critique
  List<String> get likes => throw _privateConstructorUsedError;

  /// Genres the movie belongs to
  List<String> get genres => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CritiqueModelCopyWith<CritiqueModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CritiqueModelCopyWith<$Res> {
  factory $CritiqueModelCopyWith(
          CritiqueModel value, $Res Function(CritiqueModel) then) =
      _$CritiqueModelCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String message,
      String imdbID,
      String uid,
      DateTime created,
      DateTime modified,
      double rating,
      List<String> likes,
      List<String> genres});
}

/// @nodoc
class _$CritiqueModelCopyWithImpl<$Res>
    implements $CritiqueModelCopyWith<$Res> {
  _$CritiqueModelCopyWithImpl(this._value, this._then);

  final CritiqueModel _value;
  // ignore: unused_field
  final $Res Function(CritiqueModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? imdbID = freezed,
    Object? uid = freezed,
    Object? created = freezed,
    Object? modified = freezed,
    Object? rating = freezed,
    Object? likes = freezed,
    Object? genres = freezed,
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
      modified: modified == freezed
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      likes: likes == freezed
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      genres: genres == freezed
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$CritiqueModelCopyWith<$Res>
    implements $CritiqueModelCopyWith<$Res> {
  factory _$CritiqueModelCopyWith(
          _CritiqueModel value, $Res Function(_CritiqueModel) then) =
      __$CritiqueModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String message,
      String imdbID,
      String uid,
      DateTime created,
      DateTime modified,
      double rating,
      List<String> likes,
      List<String> genres});
}

/// @nodoc
class __$CritiqueModelCopyWithImpl<$Res>
    extends _$CritiqueModelCopyWithImpl<$Res>
    implements _$CritiqueModelCopyWith<$Res> {
  __$CritiqueModelCopyWithImpl(
      _CritiqueModel _value, $Res Function(_CritiqueModel) _then)
      : super(_value, (v) => _then(v as _CritiqueModel));

  @override
  _CritiqueModel get _value => super._value as _CritiqueModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
    Object? imdbID = freezed,
    Object? uid = freezed,
    Object? created = freezed,
    Object? modified = freezed,
    Object? rating = freezed,
    Object? likes = freezed,
    Object? genres = freezed,
  }) {
    return _then(_CritiqueModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      modified: modified == freezed
          ? _value.modified
          : modified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rating: rating == freezed
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      likes: likes == freezed
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      genres: genres == freezed
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CritiqueModel implements _CritiqueModel {
  _$_CritiqueModel(
      {@JsonKey(name: '_id') this.id,
      required this.message,
      required this.imdbID,
      required this.uid,
      required this.created,
      required this.modified,
      required this.rating,
      required this.likes,
      required this.genres});

  factory _$_CritiqueModel.fromJson(Map<String, dynamic> json) =>
      _$$_CritiqueModelFromJson(json);

  @override

  /// Id of the critique
  @JsonKey(name: '_id')
  final String? id;
  @override

  /// The review of the movie
  final String message;
  @override

  /// Movie Id
  final String imdbID;
  @override

  /// User Id associated with this critique
  final String uid;
  @override

  /// Comments
// required List<CommentModel> comments,TODO: Uncomment this after new UI of critique details page.
  /// Time this was posted
  final DateTime created;
  @override

  /// Time this was modified
  final DateTime modified;
  @override

  /// Rating of movie
  final double rating;
  @override

  /// Users who liked the critique
  final List<String> likes;
  @override

  /// Genres the movie belongs to
  final List<String> genres;

  @override
  String toString() {
    return 'CritiqueModel(id: $id, message: $message, imdbID: $imdbID, uid: $uid, created: $created, modified: $modified, rating: $rating, likes: $likes, genres: $genres)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CritiqueModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.imdbID, imdbID) || other.imdbID == imdbID) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.modified, modified) ||
                other.modified == modified) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other.likes, likes) &&
            const DeepCollectionEquality().equals(other.genres, genres));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      message,
      imdbID,
      uid,
      created,
      modified,
      rating,
      const DeepCollectionEquality().hash(likes),
      const DeepCollectionEquality().hash(genres));

  @JsonKey(ignore: true)
  @override
  _$CritiqueModelCopyWith<_CritiqueModel> get copyWith =>
      __$CritiqueModelCopyWithImpl<_CritiqueModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CritiqueModelToJson(this);
  }
}

abstract class _CritiqueModel implements CritiqueModel {
  factory _CritiqueModel(
      {@JsonKey(name: '_id') String? id,
      required String message,
      required String imdbID,
      required String uid,
      required DateTime created,
      required DateTime modified,
      required double rating,
      required List<String> likes,
      required List<String> genres}) = _$_CritiqueModel;

  factory _CritiqueModel.fromJson(Map<String, dynamic> json) =
      _$_CritiqueModel.fromJson;

  @override

  /// Id of the critique
  @JsonKey(name: '_id')
  String? get id;
  @override

  /// The review of the movie
  String get message;
  @override

  /// Movie Id
  String get imdbID;
  @override

  /// User Id associated with this critique
  String get uid;
  @override

  /// Comments
// required List<CommentModel> comments,TODO: Uncomment this after new UI of critique details page.
  /// Time this was posted
  DateTime get created;
  @override

  /// Time this was modified
  DateTime get modified;
  @override

  /// Rating of movie
  double get rating;
  @override

  /// Users who liked the critique
  List<String> get likes;
  @override

  /// Genres the movie belongs to
  List<String> get genres;
  @override
  @JsonKey(ignore: true)
  _$CritiqueModelCopyWith<_CritiqueModel> get copyWith =>
      throw _privateConstructorUsedError;
}
