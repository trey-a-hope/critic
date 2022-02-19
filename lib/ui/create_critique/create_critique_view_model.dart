import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CreateCritiqueViewModel extends GetxController {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  void saveCritique() {
    _critiqueService.create(
      critique: CritiqueModel(
        message: 'This is a great movie',
        imdbID: 'tt0120338',
        uid: _getStorage.read('uid'),
        created: DateTime.now(),
        modified: DateTime.now(),
        rating: 3,
        likes: [],
        genres: [],
      ),
    );
  }
}
