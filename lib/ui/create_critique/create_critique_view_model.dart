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

  /// Indicator that the page is loading.
  bool _isLoading = true;

  @override
  void onInit() async {
    super.onInit();
    // Turn off loading indicator.
    _isLoading = false;

    update();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  bool get isLoading => _isLoading;

  Future<bool> saveCritique() async {
    try {
      // Turn on loading indicator.
      _isLoading = true;

      update();

      // Build critique object.
      CritiqueModel critique = CritiqueModel(
        message: _message,
        imdbID: _movie!.imdbID,
        uid: _getStorage.read('uid'),
        created: DateTime.now(),
        modified: DateTime.now(),
        rating: _rating,
        likes: [],
      );

      // Submit the critique.
      await _critiqueService.create(
        critique: critique,
      );

      // Turn off loading indicator.
      _isLoading = false;

      update();

      return true;
    } catch (e) {
      // Turn off loading indicator.
      _isLoading = false;

      update();

      debugPrint(e.toString());
      return false;
    }
  }

  /// Update the rating for the critique.
  void updateRating({required double rating}) {
    _rating = rating;
    update();
  }

  /// Update the message for the critique.
  void updateMessage({required String message}) {
    _message = message;
    update();
  }

  /// Update the selected movie.
  void updateMovie({required MovieModel movie}) {
    _movie = movie;
    update();
  }

  /// Indicator that a movie has been selected.
  bool movieSelected() {
    return _movie != null;
  }

  void clearMovie() {
    _movie = null;
    update();
  }

  MovieModel? get movie => _movie;
}
