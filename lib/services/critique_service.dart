import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/critique_model.dart';
import 'package:critic/services/stream_feed_service.dart';
import 'package:get/get.dart';

import 'package:stream_feed/stream_feed.dart';

class CritiqueService extends GetxService {
  /// Instantiate stream feed service.
  final StreamFeedService _streamFeedService = Get.find();

  /// Create reference to the critiques collection in Firestore.
  final CollectionReference _critiquesDB =
      FirebaseFirestore.instance.collection('critiques');

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
}
