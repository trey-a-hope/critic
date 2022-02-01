// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'search_movies_result_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SearchMoviesResultItemModel _$SearchMoviesResultItemModelFromJson(
    Map<String, dynamic> json) {
  return _SearchMoviesResultItemModel.fromJson(json);
}

/// @nodoc
class _$SearchMoviesResultItemModelTearOff {
  const _$SearchMoviesResultItemModelTearOff();

  _SearchMoviesResultItemModel call(
      {required String imdbID,
      @JsonKey(name: 'Title') required String title,
      @JsonKey(name: 'Poster') required String poster,
      @JsonKey(name: 'Type') required String type,
      @JsonKey(name: 'Year') required String year}) {
    return _SearchMoviesResultItemModel(
      imdbID: imdbID,
      title: title,
      poster: poster,
      type: type,
      year: year,
    );
  }

  SearchMoviesResultItemModel fromJson(Map<String, Object?> json) {
    return SearchMoviesResultItemModel.fromJson(json);
  }
}

/// @nodoc
const $SearchMoviesResultItemModel = _$SearchMoviesResultItemModelTearOff();

/// @nodoc
mixin _$SearchMoviesResultItemModel {
  /// Id of the movie.
  String get imdbID => throw _privateConstructorUsedError;

  /// Title of movie.
  @JsonKey(name: 'Title')
  String get title => throw _privateConstructorUsedError;

  /// Image url of the poster.
  @JsonKey(name: 'Poster')
  String get poster => throw _privateConstructorUsedError;

  /// Type of movie.
  @JsonKey(name: 'Type')
  String get type => throw _privateConstructorUsedError;

  /// Year the movie was released.
  @JsonKey(name: 'Year')
  String get year => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchMoviesResultItemModelCopyWith<SearchMoviesResultItemModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchMoviesResultItemModelCopyWith<$Res> {
  factory $SearchMoviesResultItemModelCopyWith(
          SearchMoviesResultItemModel value,
          $Res Function(SearchMoviesResultItemModel) then) =
      _$SearchMoviesResultItemModelCopyWithImpl<$Res>;
  $Res call(
      {String imdbID,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Poster') String poster,
      @JsonKey(name: 'Type') String type,
      @JsonKey(name: 'Year') String year});
}

/// @nodoc
class _$SearchMoviesResultItemModelCopyWithImpl<$Res>
    implements $SearchMoviesResultItemModelCopyWith<$Res> {
  _$SearchMoviesResultItemModelCopyWithImpl(this._value, this._then);

  final SearchMoviesResultItemModel _value;
  // ignore: unused_field
  final $Res Function(SearchMoviesResultItemModel) _then;

  @override
  $Res call({
    Object? imdbID = freezed,
    Object? title = freezed,
    Object? poster = freezed,
    Object? type = freezed,
    Object? year = freezed,
  }) {
    return _then(_value.copyWith(
      imdbID: imdbID == freezed
          ? _value.imdbID
          : imdbID // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      poster: poster == freezed
          ? _value.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      year: year == freezed
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$SearchMoviesResultItemModelCopyWith<$Res>
    implements $SearchMoviesResultItemModelCopyWith<$Res> {
  factory _$SearchMoviesResultItemModelCopyWith(
          _SearchMoviesResultItemModel value,
          $Res Function(_SearchMoviesResultItemModel) then) =
      __$SearchMoviesResultItemModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String imdbID,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Poster') String poster,
      @JsonKey(name: 'Type') String type,
      @JsonKey(name: 'Year') String year});
}

/// @nodoc
class __$SearchMoviesResultItemModelCopyWithImpl<$Res>
    extends _$SearchMoviesResultItemModelCopyWithImpl<$Res>
    implements _$SearchMoviesResultItemModelCopyWith<$Res> {
  __$SearchMoviesResultItemModelCopyWithImpl(
      _SearchMoviesResultItemModel _value,
      $Res Function(_SearchMoviesResultItemModel) _then)
      : super(_value, (v) => _then(v as _SearchMoviesResultItemModel));

  @override
  _SearchMoviesResultItemModel get _value =>
      super._value as _SearchMoviesResultItemModel;

  @override
  $Res call({
    Object? imdbID = freezed,
    Object? title = freezed,
    Object? poster = freezed,
    Object? type = freezed,
    Object? year = freezed,
  }) {
    return _then(_SearchMoviesResultItemModel(
      imdbID: imdbID == freezed
          ? _value.imdbID
          : imdbID // ignore: cast_nullable_to_non_nullable
              as String,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      poster: poster == freezed
          ? _value.poster
          : poster // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      year: year == freezed
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SearchMoviesResultItemModel implements _SearchMoviesResultItemModel {
  _$_SearchMoviesResultItemModel(
      {required this.imdbID,
      @JsonKey(name: 'Title') required this.title,
      @JsonKey(name: 'Poster') required this.poster,
      @JsonKey(name: 'Type') required this.type,
      @JsonKey(name: 'Year') required this.year});

  factory _$_SearchMoviesResultItemModel.fromJson(Map<String, dynamic> json) =>
      _$$_SearchMoviesResultItemModelFromJson(json);

  @override

  /// Id of the movie.
  final String imdbID;
  @override

  /// Title of movie.
  @JsonKey(name: 'Title')
  final String title;
  @override

  /// Image url of the poster.
  @JsonKey(name: 'Poster')
  final String poster;
  @override

  /// Type of movie.
  @JsonKey(name: 'Type')
  final String type;
  @override

  /// Year the movie was released.
  @JsonKey(name: 'Year')
  final String year;

  @override
  String toString() {
    return 'SearchMoviesResultItemModel(imdbID: $imdbID, title: $title, poster: $poster, type: $type, year: $year)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchMoviesResultItemModel &&
            (identical(other.imdbID, imdbID) || other.imdbID == imdbID) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.poster, poster) || other.poster == poster) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.year, year) || other.year == year));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, imdbID, title, poster, type, year);

  @JsonKey(ignore: true)
  @override
  _$SearchMoviesResultItemModelCopyWith<_SearchMoviesResultItemModel>
      get copyWith => __$SearchMoviesResultItemModelCopyWithImpl<
          _SearchMoviesResultItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SearchMoviesResultItemModelToJson(this);
  }
}

abstract class _SearchMoviesResultItemModel
    implements SearchMoviesResultItemModel {
  factory _SearchMoviesResultItemModel(
          {required String imdbID,
          @JsonKey(name: 'Title') required String title,
          @JsonKey(name: 'Poster') required String poster,
          @JsonKey(name: 'Type') required String type,
          @JsonKey(name: 'Year') required String year}) =
      _$_SearchMoviesResultItemModel;

  factory _SearchMoviesResultItemModel.fromJson(Map<String, dynamic> json) =
      _$_SearchMoviesResultItemModel.fromJson;

  @override

  /// Id of the movie.
  String get imdbID;
  @override

  /// Title of movie.
  @JsonKey(name: 'Title')
  String get title;
  @override

  /// Image url of the poster.
  @JsonKey(name: 'Poster')
  String get poster;
  @override

  /// Type of movie.
  @JsonKey(name: 'Type')
  String get type;
  @override

  /// Year the movie was released.
  @JsonKey(name: 'Year')
  String get year;
  @override
  @JsonKey(ignore: true)
  _$SearchMoviesResultItemModelCopyWith<_SearchMoviesResultItemModel>
      get copyWith => throw _privateConstructorUsedError;
}
