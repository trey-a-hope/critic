import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_model.freezed.dart';

part 'recipe_model.g.dart';

@freezed
class RecipeModel with _$RecipeModel {
  factory RecipeModel({

    /// The id of the recipe.
    required String id,

    /// The entered text for the food item.
    required String foodItem,

    /// The image of the recipe.
    required dynamic image,

    /// Title of the recipe.
    required String title,

    /// Instructions for the recipe.
    @JsonKey(name: 'instructionsFormatted') required String instructions,

  }) = _RecipeModel;

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);
}

//flutter pub run build_runner build --delete-conflicting-outputs