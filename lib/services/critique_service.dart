import 'package:critic/constants/globals.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:stream_feed/stream_feed.dart';

class CritiqueService extends GetxService {
  /// Instantiate stream feed service.
  final StreamFeedService _streamFeedService = Get.find();

  Future<List<CritiqueModel>> list({
    required int limit,
    String? lastID,
    String? uid,
    String? imdbID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${Globals.CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesList'),
        body: json.encode({
          'limit': limit,
          'last_id': lastID,
          'uid': uid,
          'imdbID': imdbID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final List<dynamic> results = json.decode(response.body) as List<dynamic>;

      List<CritiqueModel> critiques = results
          .map(
            (result) => CritiqueModel.fromJson(result),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> create({required CritiqueModel critique}) async {
    try {
      // Create activity in Stream that represents this critique.
      String activityID = await _streamFeedService.addActivity();

      // Update activity id of the critique.
      CritiqueModel _critique = critique.copyWith(activityID: activityID);

      http.Response response = await http.post(
        Uri.parse('${Globals.CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCreate'),
        body: json.encode(_critique.toJson()),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> getFeed({
    required int limit,
    required int offset,
  }) async {
    try {
      List<Activity> activities = await _streamFeedService.getActivities(
        limit: limit,
        offset: offset,
      );

      List<CritiqueModel> critiques = [];

      for (int i = 0; i < activities.length; i++) {
        Activity activity = activities[i];

        String activityID = activity.id!;

        CritiqueModel critique = await retrieve(activityID: activityID);

        critiques.add(critique);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<CritiqueModel> retrieve({String? id, String? activityID}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${Globals.CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesGet'),
        body: json.encode({
          'id': id,
          'activityID': activityID,
        }),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      final dynamic result = json.decode(response.body);

      CritiqueModel critique = CritiqueModel.fromJson(result);

      return critique;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
