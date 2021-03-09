import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/RecommendationModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IRecommendationsService {
  Future<void> createRecommendation({
    @required String sendeeUID,
    @required RecommendationModel recommendation,
  });

  Future<void> deleteRecommendation({
    @required String sendeeUID,
    @required String recommendationID,
  });
  Future<Stream<QuerySnapshot>> streamRecommendations({
    @required String uid,
  });
}

class RecommendationsService extends IRecommendationsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  static const String _RECOMMENDATIONS_TABLE_NAME = 'recommendations';

  @override
  Future<void> createRecommendation(
      {@required String sendeeUID,
      @required RecommendationModel recommendation}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference sendeeDocRef = _usersDB.doc(sendeeUID);

      final CollectionReference recommendationsColRef =
          sendeeDocRef.collection(_RECOMMENDATIONS_TABLE_NAME);

      DocumentReference newRecommendationDocRef = recommendationsColRef.doc();

      recommendation.id = newRecommendationDocRef.id;

      Map recommendationMap = recommendation.toMap();

      batch.set(
        newRecommendationDocRef,
        recommendationMap,
      );

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<Stream<QuerySnapshot>> streamRecommendations(
      {@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference recommendations =
          userDocRef.collection(_RECOMMENDATIONS_TABLE_NAME);

      return recommendations.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteRecommendation({
    @required String sendeeUID,
    @required String recommendationID,
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