import 'package:critic/models/data/recipe_model.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';

class RecipeRepository extends GetxService {
  /// Collection title, 'Recipe'.
  final String _collection = 'Recipe';

  /// Firestore service.
  final FirestoreService _firestoreService = Get.find();


  /// Update the recipel.
  Future<void> updateFoodItem({required String foodItem, required RecipeModel recipe}) async {
    try {
    await _firestoreService.updateDocument(collection: _collection, data: {'foodItem': foodItem}, documentID: recipe.id);
   return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Return the recipe.
  Future<RecipeModel> retrieveRecipe() async {
    try {
      RecipeModel recipe =
      (await _firestoreService.retrieveDocuments(collection: _collection))!
          .map((e) => e.data() as RecipeModel)
          .toList().first;

      return recipe;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}