import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/Constants.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class ICritiqueService {
  //complete
  Future<void> createCritique({@required CritiqueModel critique});
  Future<List<CritiqueModel>> retrieveCritiquesFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  });
  Future<List<CritiqueModel>> retrieveCritiquesFromFirebase({
    @required String uid,
    @required int limit,
    @required int offset,
  });
  Future<void> deleteCritique({
    @required String critiqueID,
    @required String uid,
  });
  //not complete
  // Future<CritiqueModel> getCritique({@required String critiqueID});
  // Future<List<CritiqueModel>> retrieveCritiquesForUser({
  //   @required String userID,
  // });
  // Future<void> updateCritique(
  //     {@required String critiqueID, @required dynamic data});
}

class CritiqueService extends ICritiqueService {
  final CollectionReference _critiquesDB =
      FirebaseFirestore.instance.collection('Critiques');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');
  final CollectionReference _followersDB =
      FirebaseFirestore.instance.collection('Followers');

  @override
  Future<void> createCritique({@required CritiqueModel critique}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}AddCritiqueToFeed',
        body: critique.toJson(),
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      );

      Map map = json.decode(response.body);

      if (map['statusCode'] != null) {
        throw PlatformException(
          message: map['raw']['message'],
          code: map['raw']['code'],
        );
      }

      final String critiqueID = map['id'];

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);
      batch.set(
        critiqueDocRef,
        {
          'commentCount': 0,
          'likeCount': 0,
          'likes': [],
          'id': critiqueID,
        },
      );

      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');
      batch.update(
        tableCountsDocRef,
        {
          'critiques': FieldValue.increment(1),
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
  Future<List<CritiqueModel>> retrieveCritiquesFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  }) async {
    try {
      try {
        Map data = {
          'uid': uid,
          'limit': '$limit',
          'offset': '$offset',
        };

        http.Response response = await http.post(
          '${CLOUD_FUNCTIONS_ENDPOINT}GetUserFeed',
          body: data,
          headers: {'content-type': 'application/x-www-form-urlencoded'},
        );

        Map map = json.decode(response.body);

        if (map['statusCode'] != null) {
          throw PlatformException(
              message: map['raw']['message'], code: map['raw']['code']);
        }

        final List<dynamic> results = map['results'];

        List<CritiqueModel> critiques = results
            .map(
              (result) => CritiqueModel.fromJSON(map: result),
            )
            .toList();

        return critiques;
      } catch (e) {
        throw Exception(
          e.toString(),
        );
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteCritique({
    @required String critiqueID,
    @required String uid,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}DeleteCritiqueFromFeed',
        body: {
          'uid': uid,
          'critiqueID': critiqueID,
        },
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      );

      Map map = json.decode(response.body);

      if (map['statusCode'] != null) {
        throw PlatformException(
          message: map['raw']['message'],
          code: map['raw']['code'],
        );
      }

      final WriteBatch batch = FirebaseFirestore.instance.batch();
      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);
      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');

      batch.delete(
        critiqueDocRef,
      );

      batch.update(
        tableCountsDocRef,
        {
          'critiques': FieldValue.increment(-1),
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
  Future<List<CritiqueModel>> retrieveCritiquesFromFirebase({
    @required String uid,
    @required int limit,
    @required int offset,
  }) {
    // TODO: implement retrieveCritiquesFromFirebase
    throw UnimplementedError();
  }
}
