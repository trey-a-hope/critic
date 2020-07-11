import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';

abstract class ICritiqueService {
  Future<void> createCritique({@required CritiqueModel critique});
  Future<CritiqueModel> getCritique({@required String critiqueID});
  Future<List<CritiqueModel>> retrieveCritiques();
  Future<List<CritiqueModel>> retrieveCritiquesForUser({
    @required String userID,
  });
  Future<void> updateCritique(
      {@required String critiqueID, @required dynamic data});
  Future<void> deleteCritique({
    @required String critiqueID,
    @required String userID,
    @required DateTime created,
  });
}

class CritiqueService extends ICritiqueService {
  final CollectionReference _critiquesDB =
      Firestore.instance.collection('Critiques');
  final CollectionReference _dataDB = Firestore.instance.collection('Data');
  final CollectionReference _followersDB =
      Firestore.instance.collection('Followers');

  @override
  Future<void> createCritique({@required CritiqueModel critique}) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference critiqueDocRef = _critiquesDB.document();
      critique.id = critiqueDocRef.documentID;
      batch.setData(
        critiqueDocRef,
        critique.toMap(),
      );

      final DocumentReference tableCountsDocRef =
          _dataDB.document('tableCounts');
      batch.updateData(
        tableCountsDocRef,
        {
          'critiques': FieldValue.increment(1),
        },
      );

      final DocumentReference followerDoc =
          _followersDB.document(critique.userID);
      batch.updateData(
        followerDoc,
        {
          'lastPost': DateTime.now(),
          'recentPosts': FieldValue.arrayUnion(
            [
              critique.id,
            ],
          )
        },
      );

      batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> retrieveCritiques({bool safe}) async {
    try {
      Query query = _critiquesDB;

      if (safe != null) {
        query = query.where('safe', isEqualTo: safe);
      }

      QuerySnapshot querySnapshot = await query.getDocuments();

      List<CritiqueModel> critiques = querySnapshot.documents
          .map(
            (DocumentSnapshot documentSnapshot) =>
                CritiqueModel.extractDocument(ds: documentSnapshot),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> updateCritique({
    @required String critiqueID,
    @required dynamic data,
  }) async {
    try {
      await _critiquesDB.document(critiqueID).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<CritiqueModel> getCritique({
    @required String critiqueID,
  }) async {
    try {
      DocumentSnapshot documentSnapshot =
          (await _critiquesDB.document(critiqueID).get());

      return CritiqueModel.extractDocument(ds: documentSnapshot);
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> retrieveCritiquesForUser(
      {@required String userID}) async {
    try {
      Query query = _critiquesDB.where('userID', isEqualTo: userID);

      QuerySnapshot querySnapshot = await query.getDocuments();

      List<CritiqueModel> critiques = querySnapshot.documents
          .map(
            (DocumentSnapshot documentSnapshot) =>
                CritiqueModel.extractDocument(ds: documentSnapshot),
          )
          .toList();

      return critiques;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteCritique({
    @required String critiqueID,
    @required String userID,
    @required DateTime created,
  }) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      batch.delete(
        _critiquesDB.document(critiqueID),
      );

      batch.updateData(
        _dataDB.document('tableCounts'),
        {
          'critiques': FieldValue.increment(-1),
        },
      );

      batch.updateData(_followersDB.document(userID), {
        'recentPosts': FieldValue.arrayRemove(
          [
            critiqueID,
          ],
        )
      });

      batch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
