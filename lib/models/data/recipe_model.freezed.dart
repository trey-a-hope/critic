// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'recipe_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RecipeModel _$RecipeModelFromJson(Map<String, dynamic> json) {
  return _RecipeModel.fromJson(json);
}

/// @nodoc
class _$RecipeModelTearOff {
  const _$RecipeModelTearOff();

  _RecipeModel call(
      {required String id,
      required String foodItem,
      required dynamic image,
      required String title,
      @JsonKey(name: 'instructionsFormatted') required String instructions}) {
    return _RecipeModel(
      id: id,
      foodItem: foodItem,
      image: image,
      title: title,
      instructions: instructions,
    );
  }

  RecipeModel fromJson(Map<String, Object?> json) {
    return RecipeModel.fromJson(json);
  }
}

/// @nodoc
const $RecipeModel = _$RecipeModelTearOff();

/// @nodoc
mixin _$RecipeModel {
  /// The id of the recipe.
  String get id => throw _privateConstructorUsedError;

  /// The entered text for the food item.
  String get foodItem => throw _privateConstructorUsedError;

  /// The image of the recipe.
  dynamic get image => throw _privateConstructorUsedError;

  /// Title of the recipe.
  String get title => throw _privateConstructorUsedError;

  /// Instructions for the recipe.
  @JsonKey(name: 'instructionsFormatted')
  String get instructions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecipeModelCopyWith<RecipeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeModelCopyWith<$Res> {
  factory $RecipeModelCopyWith(
          RecipeModel value, $Res Function(RecipeModel) then) =
      _$RecipeModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String foodItem,
      dynamic image,
      String title,
      @JsonKey(name: 'instructionsFormatted') String instructions});
}

/// @nodoc
class _$RecipeModelCopyWithImpl<$Res> implements $RecipeModelCopyWith<$Res> {
  _$RecipeModelCopyWithImpl(this._value, this._then);

  final RecipeModel _value;
  // ignore: unused_field
  final $Res Function(RecipeModel) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? foodItem = freezed,
    Object? image = freezed,
    Object? title = freezed,
    Object? instructions = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      foodItem: foodItem == freezed
          ? _value.foodItem
          : foodItem // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as dynamic,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: instructions == freezed
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$RecipeModelCopyWith<$Res>
    implements $RecipeModelCopyWith<$Res> {
  factory _$RecipeModelCopyWith(
          _RecipeModel value, $Res Function(_RecipeModel) then) =
      __$RecipeModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String foodItem,
      dynamic image,
      String title,
      @JsonKey(name: 'instructionsFormatted') String instructions});
}

/// @nodoc
class __$RecipeModelCopyWithImpl<$Res> extends _$RecipeModelCopyWithImpl<$Res>
    implements _$RecipeModelCopyWith<$Res> {
  __$RecipeModelCopyWithImpl(
      _RecipeModel _value, $Res Function(_RecipeModel) _then)
      : super(_value, (v) => _then(v as _RecipeModel));

  @override
  _RecipeModel get _value => super._value as _RecipeModel;

  @override
  $Res call({
    Object? id = freezed,
    Object? foodItem = freezed,
    Object? image = freezed,
    Object? title = freezed,
    Object? instructions = freezed,
  }) {
    return _then(_RecipeModel(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      foodItem: foodItem == freezed
          ? _value.foodItem
          : foodItem // ignore: cast_nullable_to_non_nullable
              as String,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as dynamic,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      instructions: instructions == freezed
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_RecipeModel implements _RecipeModel {
  _$_RecipeModel(
      {required this.id,
      required this.foodItem,
      required this.image,
      required this.title,
      @JsonKey(name: 'instructionsFormatted') required this.instructions});

  factory _$_RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$$_RecipeModelFromJson(json);

  @override

  /// The id of the recipe.
  final String id;
  @override

  /// The entered text for the food item.
  final String foodItem;
  @override

  /// The image of the recipe.
  final dynamic image;
  @override

  /// Title of the recipe.
  final String title;
  @override

  /// Instructions for the recipe.
  @JsonKey(name: 'instructionsFormatted')
  final String instructions;

  @override
  String toString() {
    return 'RecipeModel(id: $id, foodItem: $foodItem, image: $image, title: $title, instructions: $instructions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecipeModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, foodItem,
      const DeepCollectionEquality().hash(image), title, instructions);

  @JsonKey(ignore: true)
  @override
  _$RecipeModelCopyWith<_RecipeModel> get copyWith =>
      __$RecipeModelCopyWithImpl<_RecipeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RecipeModelToJson(this);
  }
}

abstract class _RecipeModel implements RecipeModel {
  factory _RecipeModel(
      {required String id,
      required String foodItem,
      required dynamic image,
      required String title,
      @JsonKey(name: 'instructionsFormatted')
          required String instructions}) = _$_RecipeModel;

  factory _RecipeModel.fromJson(Map<String, dynamic> json) =
      _$_RecipeModel.fromJson;

  @override

  /// The id of the recipe.
  String get id;
  @override

  /// The entered text for the food item.
  String get foodItem;
  @override

  /// The image of the recipe.
  dynamic get image;
  @override

  /// Title of the recipe.
  String get title;
  @override

  /// Instructions for the recipe.
  @JsonKey(name: 'instructionsFormatted')
  String get instructions;
  @override
  @JsonKey(ignore: true)
  _$RecipeModelCopyWith<_RecipeModel> get copyWith =>
      throw _privateConstructorUsedError;
}
