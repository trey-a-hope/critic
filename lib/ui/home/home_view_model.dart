import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Critiques.
  List<CritiqueModel> critiques = [];

  @override
  void onInit() async {
    /// Retrieve feed.
    critiques = await _critiqueService.getFeed();

    update();

    super.onInit();
  }
}
