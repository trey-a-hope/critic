import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';

abstract class ICritiqueService {
  Future<void> createCritique({@required CritiqueModel critique});
}

class CritiqueService extends ICritiqueService {
  final CollectionReference critiquesDB =
      Firestore.instance.collection('Critiques');
  final CollectionReference dataDB = Firestore.instance.collection('Data');

  @override
  Future<void> createCritique({@required CritiqueModel critique}) async {
    try {
      //Create new batch object.
      final WriteBatch batch = Firestore.instance.batch();
      //Create document reference for the new item.
      final DocumentReference critiqueDocRef = critiquesDB.document();
      //Create document reference for the table counts.
      final DocumentReference tableCountsDocRef =
          dataDB.document('tableCounts');
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
}
