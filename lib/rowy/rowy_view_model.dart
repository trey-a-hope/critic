part of 'rowy_view.dart';

class _RowyViewModel extends GetxController {
  // Recipe repository.
  final RecipeRepository _recipeRepository = Get.find();

  // Text controller for entering food item.
  TextEditingController _foodItemController = TextEditingController();
  TextEditingController get foodItemController => _foodItemController;

  // Recipe.
  late RecipeModel _recipe;
  RecipeModel get recipe => _recipe;

  // Flag representing if the app is loading.
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  @override
  void onInit() async {
    super.onInit();
    try {
      // Fetch the recipe.
      _recipe = await _recipeRepository.retrieveRecipe();

      // Set the food item to the value on the recipe.
      foodItemController.text = _recipe.foodItem;

      _isLoading = false;

      // Listen for changes to the current recipe.
      FirebaseFirestore.instance
          .collection('Recipe')
          .doc(_recipe.id)
          .withConverter<RecipeModel>(
          fromFirestore: (snapshot, _) =>
              RecipeModel.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson())
          .snapshots()
          .listen((DocumentSnapshot documentSnapshot) {
        RecipeModel rm = documentSnapshot.data() as RecipeModel;

        _recipe = rm;

        update();
      }).onError((e) => print(e));

      update();
    } catch (e) {
      print(e);
    }
  }

  @override
  void onReady() async {


    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  /// Submit new food item.
  Future<void> submit() async {
    try {
      _isLoading = true;
      update();

      await _recipeRepository.updateFoodItem(
          foodItem: _foodItemController.text, recipe: recipe);

      _isLoading = false;
      update();
      return;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
