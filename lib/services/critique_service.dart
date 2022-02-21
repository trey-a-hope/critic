import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/constants.dart';
import 'package:critic/models/data/comment_model.dart';
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

  /// Create reference to the critiques collection in Firestore.
  final CollectionReference _critiquesDB =
      FirebaseFirestore.instance.collection('critiques');

  Future<CritiqueModel> get({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesGet'),
        body: json.encode({
          'id': id,
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

  Future<List<CritiqueModel>> listByUser({
    required String uid,
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesListByUser'),
        body: json.encode({
          'uid': uid,
          'limit': limit,
          'last_id': lastID,
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

  Future<List<CritiqueModel>> listFromFirebase({
    required int limit,
    required DateTime? lastDateTime,
  }) async {
    try {
      /// Query the critiques from most recent to oldest with a limit.
      Query query =
          _critiquesDB.orderBy('created', descending: true).limit(limit);

      /// For pagination, start new fetch after the last document's created date.
      if (lastDateTime != null) {
        query = query.startAfter([lastDateTime.toIso8601String()]);
      }

      /// Perform query then save the docu
      List<QueryDocumentSnapshot<Object?>> querySnapshot =
          (await query.get()).docs;

      /// Create document references from query snapshot.
      List<DocumentReference<CritiqueModel>> docRefs = querySnapshot
          .map((e) => e.reference.withConverter<CritiqueModel>(
              fromFirestore: (snapshot, _) =>
                  CritiqueModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson()))
          .toList();

      /// Convert document references to critique objects.
      List<CritiqueModel> critiques = await Future.wait(
        docRefs.map(
          (docRef) async => ((await docRef.get()).data() as CritiqueModel),
        ),
      );

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> create({required CritiqueModel critique}) async {
    try {
      /// Create activity in Stream that represents this critique.
      String critiqueID = await _streamFeedService.addActivity();

      /// Update id of the critique.
      CritiqueModel _critique = critique.copyWith(id: critiqueID);

      /// Add critique to database.
      DocumentReference<Object?> critiqueDocRef = _critiquesDB.doc(critiqueID);
      critiqueDocRef.set(_critique.toJson());

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<CritiqueModel>> getFeed() async {
    try {
      List<Activity> activities = await _streamFeedService.getActivities();

      List<CritiqueModel> critiques = [];

      for (int i = 0; i < activities.length; i++) {
        Activity activity = activities[i];

        String critiqueID = activity.id!;

        CritiqueModel critique = await retrieve(id: critiqueID);

        critiques.add(critique);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<CritiqueModel> retrieve({required String id}) async {
    try {
      final DocumentReference model = await _critiquesDB
          .doc(id)
          .withConverter<CritiqueModel>(
              fromFirestore: (snapshot, _) =>
                  CritiqueModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson());

      return (await model.get()).data() as CritiqueModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> delete({required String id}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDelete'),
        body: json.encode({'id': id}),
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

  Future<void> update(
      {required String id, required Map<String, dynamic> params}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesUpdate'),
        body: json.encode({'id': id, 'params': params}),
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

  Future<void> addComment(
      {required String id, required CommentModel comment}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddComment'),
        body: json.encode({'id': id, 'comment': comment.toJson()}),
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

  Future<void> addLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesAddLike'),
        body: json.encode({'id': id, 'uid': uid}),
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

  /// Fetch critiques related to this movie.
  Future<List<CritiqueModel>> listSimilar({
    required String imdbID,
  }) async {
    try {
      List<QueryDocumentSnapshot<Object?>> querySnapshot =
          (await _critiquesDB.where('imdbID', isEqualTo: imdbID).get()).docs;

      List<DocumentReference<CritiqueModel>> docRefs = querySnapshot
          .map((e) => e.reference.withConverter<CritiqueModel>(
              fromFirestore: (snapshot, _) =>
                  CritiqueModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson()))
          .toList();

      var test = docRefs
          .map((docRef) async => ((await docRef.get()).data() as CritiqueModel))
          .toList();

      List<CritiqueModel> critiques = [];
      for (int i = 0; i < test.length; i++) {
        critiques.add(await test[i]);
      }

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> removeLike({
    required String id,
    required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesRemoveLike'),
        body: json.encode({'id': id, 'uid': uid}),
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

  Future<int> count({required String uid}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesCount'),
        body: json.encode({'uid': uid}),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw PlatformException(
          message: response.body,
          code: response.statusCode.toString(),
        );
      }

      return 0;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesDeleteAll'),
        //body: json.encode({'id': id}),
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

  Future<List<CritiqueModel>> list({
    required int limit,
    String? lastID,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${CLOUD_FUNCTIONS_ENDPOINT}MongoDBCritiquesList'),
        body: json.encode({
          'limit': limit,
          'last_id': lastID,
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
}
