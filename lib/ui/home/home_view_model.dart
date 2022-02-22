import 'package:critic/constants.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate stream feed service.
  final StreamFeedService _streamFeedService = Get.find();

  /// Pagination last date time for everyone critique view.
  DateTime? _everyoneTabLastDateTime;

  /// Tab controller for home view.
  late TabController controller;

  @override
  void onInit() async {
    super.onInit();

    controller = TabController(vsync: this, length: 3);

    update();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  /// Returns a paginated list of everyone's critiques.
  Future<List<CritiqueModel>> fetchEveryoneCritiques(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await _critiqueService.listFromFirebase(
      limit: PAGE_FETCH_LIMIT,
      lastDateTime: _everyoneTabLastDateTime,
    );

    if (critiques.isEmpty) return critiques;

    _everyoneTabLastDateTime = critiques[critiques.length - 1].created;

    return critiques;
  }

  /// Restart pagination from the top.
  void resetEveryoneTabLastDateTime() {
    _everyoneTabLastDateTime = null;
  }
}
