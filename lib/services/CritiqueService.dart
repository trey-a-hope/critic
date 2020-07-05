import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';

abstract class ICritiqueService {
  Future<void> createCritique({@required CritiqueModel critique});
  Future<List<CritiqueModel>> retrieveCritiques();
}

class CritiqueService extends ICritiqueService {
  final CollectionReference _critiquesDB =
      Firestore.instance.collection('Critiques');
  final CollectionReference _dataDB = Firestore.instance.collection('Data');

  @override
  Future<void> createCritique({@required CritiqueModel critique}) async {
    try {
      //Create new batch object.
      final WriteBatch batch = Firestore.instance.batch();
      //Create document reference for the new item.
      final DocumentReference critiqueDocRef = _critiquesDB.document();
      //Create document reference for the table counts.
      final DocumentReference tableCountsDocRef =
          _dataDB.document('tableCounts');
      //Set data for new reference.
      critique.id = critiqueDocRef.documentID;
      //Set data for user.
      batch.setData(critiqueDocRef, critique.toMap());
      //Increase count value for total likes on this template.
      batch.updateData(
          tableCountsDocRef, {'critiques': FieldValue.increment(1)});
      //Commit batch.
      batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CritiqueModel>> retrieveCritiques() async {
    try {
      QuerySnapshot querySnapshot = await _critiquesDB.getDocuments();

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
}
