// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'movie_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) {
  return _MovieModel.fromJson(json);
}

/// @nodoc
class _$MovieModelTearOff {
  const _$MovieModelTearOff();

  _MovieModel call(
      {required String imdbID,
      @JsonKey(name: 'Title') required String title,
      @JsonKey(name: 'Property') required String poster,
      @JsonKey(name: 'Released') required String released,
      @JsonKey(name: 'Plot') required String plot,
      @JsonKey(name: 'Director') required String director,
      required String imdbRating,
      required String imdbVotes,
      @JsonKey(name: 'Genre') required String genre,
      @JsonKey(name: 'Actors') required String actors,
      @JsonKey(name: 'Rated') required String rated}) {
    return _MovieModel(
      imdbID: imdbID,
      title: title,
      poster: poster,
      released: released,
      plot: plot,
      director: director,
      imdbRating: imdbRating,
      imdbVotes: imdbVotes,
      genre: genre,
      actors: actors,
      rated: rated,
    );
  }

  MovieModel fromJson(Map<String, Object?> json) {
    return MovieModel.fromJson(json);
  }
}

/// @nodoc
const $MovieModel = _$MovieModelTearOff();

/// @nodoc
mixin _$MovieModel {
  /// The id of the movie in the omdb.
  String get imdbID => throw _privateConstructorUsedError;

  /// Title of the movie.
  @JsonKey(name: 'Title')
  String get title => throw _privateConstructorUsedError;

  /// Image url of the poster.
  @JsonKey(name: 'Property')
  String get poster => throw _privateConstructorUsedError;

  /// Date the movie was released.
  @JsonKey(name: 'Released')
  String get released => throw _privateConstructorUsedError;

  /// Plot/description of movie.
  @JsonKey(name: 'Plot')
  String get plot => throw _privateConstructorUsedError;

  /// The director.
  @JsonKey(name: 'Director')
  String get director => throw _privateConstructorUsedError;

  /// Rating on imdb.
  String get imdbRating => throw _privateConstructorUsedError;

  /// Number of votes on imdb.
  String get imdbVotes => throw _privateConstructorUsedError;

  /// Movie genre.
  @JsonKey(name: 'Genre')
  String get genre => throw _privateConstructorUsedError;

  /// Actors in the movie.
  @JsonKey(name: 'Actors')
  String get actors => throw _privateConstructorUsedError;

  /// Parental rating for movie.
  @JsonKey(name: 'Rated')
  String get rated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MovieModelCopyWith<MovieModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MovieModelCopyWith<$Res> {
  factory $MovieModelCopyWith(
          MovieModel value, $Res Function(MovieModel) then) =
      _$MovieModelCopyWithImpl<$Res>;
  $Res call(
      {String imdbID,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Property') String poster,
      @JsonKey(name: 'Released') String released,
      @JsonKey(name: 'Plot') String plot,
      @JsonKey(name: 'Director') String director,
      String imdbRating,
      String imdbVotes,
      @JsonKey(name: 'Genre') String genre,
      @JsonKey(name: 'Actors') String actors,
      @JsonKey(name: 'Rated') String rated});
}

/// @nodoc
class _$MovieModelCopyWithImpl<$Res> implements $MovieModelCopyWith<$Res> {
  _$MovieModelCopyWithImpl(this._value, this._then);

  final MovieModel _value;
  // ignore: unused_field
  final $Res Function(MovieModel) _then;

  @override
  $Res call({
    Object? imdbID = freezed,
    Object? title = freezed,
    Object? poster = freezed,
    Object? released = freezed,
    Object? plot = freezed,
    Object? director = freezed,
    Object? imdbRating = freezed,
    Object? imdbVotes = freezed,
    Object? genre = freezed,
    Object? actors = freezed,
    Object? rated = freezed,
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
      released: released == freezed
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as String,
      plot: plot == freezed
          ? _value.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      director: director == freezed
          ? _value.director
          : director // ignore: cast_nullable_to_non_nullable
              as String,
      imdbRating: imdbRating == freezed
          ? _value.imdbRating
          : imdbRating // ignore: cast_nullable_to_non_nullable
              as String,
      imdbVotes: imdbVotes == freezed
          ? _value.imdbVotes
          : imdbVotes // ignore: cast_nullable_to_non_nullable
              as String,
      genre: genre == freezed
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      actors: actors == freezed
          ? _value.actors
          : actors // ignore: cast_nullable_to_non_nullable
              as String,
      rated: rated == freezed
          ? _value.rated
          : rated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MovieModelCopyWith<$Res> implements $MovieModelCopyWith<$Res> {
  factory _$MovieModelCopyWith(
          _MovieModel value, $Res Function(_MovieModel) then) =
      __$MovieModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String imdbID,
      @JsonKey(name: 'Title') String title,
      @JsonKey(name: 'Property') String poster,
      @JsonKey(name: 'Released') String released,
      @JsonKey(name: 'Plot') String plot,
      @JsonKey(name: 'Director') String director,
      String imdbRating,
      String imdbVotes,
      @JsonKey(name: 'Genre') String genre,
      @JsonKey(name: 'Actors') String actors,
      @JsonKey(name: 'Rated') String rated});
}

/// @nodoc
class __$MovieModelCopyWithImpl<$Res> extends _$MovieModelCopyWithImpl<$Res>
    implements _$MovieModelCopyWith<$Res> {
  __$MovieModelCopyWithImpl(
      _MovieModel _value, $Res Function(_MovieModel) _then)
      : super(_value, (v) => _then(v as _MovieModel));

  @override
  _MovieModel get _value => super._value as _MovieModel;

  @override
  $Res call({
    Object? imdbID = freezed,
    Object? title = freezed,
    Object? poster = freezed,
    Object? released = freezed,
    Object? plot = freezed,
    Object? director = freezed,
    Object? imdbRating = freezed,
    Object? imdbVotes = freezed,
    Object? genre = freezed,
    Object? actors = freezed,
    Object? rated = freezed,
  }) {
    return _then(_MovieModel(
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
      released: released == freezed
          ? _value.released
          : released // ignore: cast_nullable_to_non_nullable
              as String,
      plot: plot == freezed
          ? _value.plot
          : plot // ignore: cast_nullable_to_non_nullable
              as String,
      director: director == freezed
          ? _value.director
          : director // ignore: cast_nullable_to_non_nullable
              as String,
      imdbRating: imdbRating == freezed
          ? _value.imdbRating
          : imdbRating // ignore: cast_nullable_to_non_nullable
              as String,
      imdbVotes: imdbVotes == freezed
          ? _value.imdbVotes
          : imdbVotes // ignore: cast_nullable_to_non_nullable
              as String,
      genre: genre == freezed
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String,
      actors: actors == freezed
          ? _value.actors
          : actors // ignore: cast_nullable_to_non_nullable
              as String,
      rated: rated == freezed
          ? _value.rated
          : rated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MovieModel implements _MovieModel {
  _$_MovieModel(
      {required this.imdbID,
      @JsonKey(name: 'Title') required this.title,
      @JsonKey(name: 'Property') required this.poster,
      @JsonKey(name: 'Released') required this.released,
      @JsonKey(name: 'Plot') required this.plot,
      @JsonKey(name: 'Director') required this.director,
      required this.imdbRating,
      required this.imdbVotes,
      @JsonKey(name: 'Genre') required this.genre,
      @JsonKey(name: 'Actors') required this.actors,
      @JsonKey(name: 'Rated') required this.rated});

  factory _$_MovieModel.fromJson(Map<String, dynamic> json) =>
      _$$_MovieModelFromJson(json);

  @override

  /// The id of the movie in the omdb.
  final String imdbID;
  @override

  /// Title of the movie.
  @JsonKey(name: 'Title')
  final String title;
  @override

  /// Image url of the poster.
  @JsonKey(name: 'Property')
  final String poster;
  @override

  /// Date the movie was released.
  @JsonKey(name: 'Released')
  final String released;
  @override

  /// Plot/description of movie.
  @JsonKey(name: 'Plot')
  final String plot;
  @override

  /// The director.
  @JsonKey(name: 'Director')
  final String director;
  @override

  /// Rating on imdb.
  final String imdbRating;
  @override

  /// Number of votes on imdb.
  final String imdbVotes;
  @override

  /// Movie genre.
  @JsonKey(name: 'Genre')
  final String genre;
  @override

  /// Actors in the movie.
  @JsonKey(name: 'Actors')
  final String actors;
  @override

  /// Parental rating for movie.
  @JsonKey(name: 'Rated')
  final String rated;

  @override
  String toString() {
    return 'MovieModel(imdbID: $imdbID, title: $title, poster: $poster, released: $released, plot: $plot, director: $director, imdbRating: $imdbRating, imdbVotes: $imdbVotes, genre: $genre, actors: $actors, rated: $rated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieModel &&
            (identical(other.imdbID, imdbID) || other.imdbID == imdbID) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.poster, poster) || other.poster == poster) &&
            (identical(other.released, released) ||
                other.released == released) &&
            (identical(other.plot, plot) || other.plot == plot) &&
            (identical(other.director, director) ||
                other.director == director) &&
            (identical(other.imdbRating, imdbRating) ||
                other.imdbRating == imdbRating) &&
            (identical(other.imdbVotes, imdbVotes) ||
                other.imdbVotes == imdbVotes) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.actors, actors) || other.actors == actors) &&
            (identical(other.rated, rated) || other.rated == rated));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imdbID, title, poster, released,
      plot, director, imdbRating, imdbVotes, genre, actors, rated);

  @JsonKey(ignore: true)
  @override
  _$MovieModelCopyWith<_MovieModel> get copyWith =>
      __$MovieModelCopyWithImpl<_MovieModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MovieModelToJson(this);
  }
}

abstract class _MovieModel implements MovieModel {
  factory _MovieModel(
      {required String imdbID,
      @JsonKey(name: 'Title') required String title,
      @JsonKey(name: 'Property') required String poster,
      @JsonKey(name: 'Released') required String released,
      @JsonKey(name: 'Plot') required String plot,
      @JsonKey(name: 'Director') required String director,
      required String imdbRating,
      required String imdbVotes,
      @JsonKey(name: 'Genre') required String genre,
      @JsonKey(name: 'Actors') required String actors,
      @JsonKey(name: 'Rated') required String rated}) = _$_MovieModel;

  factory _MovieModel.fromJson(Map<String, dynamic> json) =
      _$_MovieModel.fromJson;

  @override

  /// The id of the movie in the omdb.
  String get imdbID;
  @override

  /// Title of the movie.
  @JsonKey(name: 'Title')
  String get title;
  @override

  /// Image url of the poster.
  @JsonKey(name: 'Property')
  String get poster;
  @override

  /// Date the movie was released.
  @JsonKey(name: 'Released')
  String get released;
  @override

  /// Plot/description of movie.
  @JsonKey(name: 'Plot')
  String get plot;
  @override

  /// The director.
  @JsonKey(name: 'Director')
  String get director;
  @override

  /// Rating on imdb.
  String get imdbRating;
  @override

  /// Number of votes on imdb.
  String get imdbVotes;
  @override

  /// Movie genre.
  @JsonKey(name: 'Genre')
  String get genre;
  @override

  /// Actors in the movie.
  @JsonKey(name: 'Actors')
  String get actors;
  @override

  /// Parental rating for movie.
  @JsonKey(name: 'Rated')
  String get rated;
  @override
  @JsonKey(ignore: true)
  _$MovieModelCopyWith<_MovieModel> get copyWith =>
      throw _privateConstructorUsedError;
}
