import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Pagination last date time for everyone critique view.
  String _everyoneTabLastID = '';

  /// Pagination last date time for my critique view.
  String _myTabLastID = '';

  /// Tab controller for home view.
  late TabController controller;

  @override
  void onInit() async {
    super.onInit();

    controller = TabController(vsync: this, length: 3);

    // _streamFeedService.createActivity(uid: _getStorage.read('uid'));

    // Delete all activites for this user.
    // List<Activity> activites =
    //     await _streamFeedService.getActivities(limit: 100, offset: 1);
    // for (int i = 0; i < activites.length; i++) {
    //   _streamFeedService.removeActivity(activityID: activites[i].id!);
    // }

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

    critiques = await _critiqueService.list(
      limit: Globals.PAGE_FETCH_LIMIT,
      lastID: _everyoneTabLastID,
    );

    if (critiques.isEmpty) return critiques;

    _everyoneTabLastID = critiques[critiques.length - 1].id!;

    return critiques;
  }

  /// Returns a paginated list of following's critiques.
  Future<List<CritiqueModel>> fetchFollowingCritiques(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await _critiqueService.getFeed(
        limit: Globals.PAGE_FETCH_LIMIT, offset: offset);

    if (critiques.isEmpty) return critiques;

    return critiques;
  }

  /// Returns a paginated list of my critiques.
  Future<List<CritiqueModel>> fetchMyCritiques(int offset) async {
    List<CritiqueModel> critiques;

    critiques = [];

    critiques = await _critiqueService.list(
      limit: Globals.PAGE_FETCH_LIMIT,
      lastID: _myTabLastID,
      uid: _getStorage.read('uid'),
    );

    if (critiques.isEmpty) return critiques;

    _myTabLastID = critiques[critiques.length - 1].id!;

    return critiques;
  }

  /// Restart pagination from the top.
  void resetLastIDs() {
    _myTabLastID = '';
    _everyoneTabLastID = '';
  }
}
