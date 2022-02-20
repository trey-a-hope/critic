import 'package:critic/models/data/critique_model.dart';
import 'package:critic/models/data/movie_model.dart';
import 'package:critic/services/critique_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CreateCritiqueViewModel extends GetxController {
  /// Instantiate critique service.
  final CritiqueService _critiqueService = Get.find();

  /// Instantiate get storage.
  final GetStorage _getStorage = GetStorage();

  /// Rating for the critique.
  double _rating = 3;

  /// Message of the critique.
  String _message = '';

  /// Movie choice.
  MovieModel? _movie;

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

  Future<bool> saveCritique() async {
    try {
      /// Build critique object.
      CritiqueModel critique = CritiqueModel(
        message: _message,
        imdbID: _movie!.imdbID,
        uid: _getStorage.read('uid'),
        created: DateTime.now(),
        modified: DateTime.now(),
        rating: _rating,
        likes: [],
      );

      /// Submit the critique.
      await _critiqueService.create(
        critique: critique,
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void updateRating({required double rating}) {
    _rating = rating;
    update();
  }

  void updateMessage({required String message}) {
    _message = message;
    update();
  }

  void updateMovie({required MovieModel movie}) {
    _movie = movie;
    update();
  }

  bool movieSelected() {
    return _movie != null;
  }

  void clearMovie() {
    _movie = null;
    update();
  }

  MovieModel? get movie => _movie;
}
