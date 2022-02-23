import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stream_feed/stream_feed.dart';

class HomeViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate stream feed service.
  final StreamFeedService _streamFeedService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Pagination last date time for everyone critique view.
  DateTime? _everyoneTabLastDateTime;

  /// Pagination last date time for my critique view.
  DateTime? _myTabLastDateTime;

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
      limit: Globals.PAGE_FETCH_LIMIT,
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

  /// Returns a paginated list of following's critiques.
  Future<List<CritiqueModel>> fetchFollowingCritiques(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    List<Activity> activities = await _streamFeedService.getActivities(
      limit: Globals.PAGE_FETCH_LIMIT,
      offset: offset,
    );

    for (int i = 0; i < activities.length; i++) {
      critiques.add(await _critiqueService.retrieve(id: activities[i].id!));
    }

    if (critiques.isEmpty) return critiques;

    return critiques;
  }

  /// Returns a paginated list of my critiques.
  Future<List<CritiqueModel>> fetchMyCritiques(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await _critiqueService.listFromFirebase(
      limit: Globals.PAGE_FETCH_LIMIT,
      lastDateTime: _myTabLastDateTime,
      uid: _getStorage.read('uid'),
    );

    if (critiques.isEmpty) return critiques;

    _myTabLastDateTime = critiques[critiques.length - 1].created;

    return critiques;
  }

  /// Restart pagination from the top.
  void resetMyTabLastDateTime() {
    _myTabLastDateTime = null;
  }
}
