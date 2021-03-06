import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/recommendation_model.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class RecommendationsService extends GetxService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  static const String _RECOMMENDATIONS_TABLE_NAME = 'recommendations';

  Future<void> createRecommendation(
      {required String sendeeUID,
      required RecommendationModel recommendation}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference sendeeDocRef = _usersDB.doc(sendeeUID);

      final CollectionReference recommendationsColRef =
          sendeeDocRef.collection(_RECOMMENDATIONS_TABLE_NAME);

      DocumentReference newRecommendationDocRef = recommendationsColRef.doc();

      String id = newRecommendationDocRef.id;

      Map map = recommendation.toJson();
      map['id'] = id;

      batch.set(
        newRecommendationDocRef,
        map,
      );

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<Stream<QuerySnapshot>> streamRecommendations(
      {required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference recommendations = userDocRef
          .collection(_RECOMMENDATIONS_TABLE_NAME)
          .withConverter<RecommendationModel>(
              fromFirestore: (snapshot, _) =>
                  RecommendationModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson());

      return recommendations.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<void> deleteRecommendation({
    required String sendeeUID,
    required String recommendationID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(sendeeUID);

      final CollectionReference recommendations =
          userDocRef.collection(_RECOMMENDATIONS_TABLE_NAME);

      final DocumentReference recommendationsDoc =
          recommendations.doc(recommendationID);

      await recommendationsDoc.delete();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
