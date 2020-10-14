import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/Constants.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

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
      FirebaseFirestore.instance.collection('Critiques');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');
  final CollectionReference _followersDB =
      FirebaseFirestore.instance.collection('Followers');

  @override
  Future<void> createCritique({@required CritiqueModel critique}) async {
    try {
      Map data = {
        'actor': critique.uid,
        'message': critique.message,
        'uid': critique.uid,
        'movieTitle': critique.movieTitle,
        'moviePoster': critique.moviePoster,
        'movieYear': critique.movieYear,
        'moviePlot': critique.moviePlot,
        'movieDirector': critique.movieDirector,
        'imdbID': critique.imdbID,
        'imdbRating': critique.imdbRating,
        'imdbVotes': critique.imdbVotes,
      };

      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}AddCritiqueToFeed',
        body: data,
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      );

      Map map = json.decode(response.body);

      if (map['statusCode'] != null) {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
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

      // final DocumentReference followerDoc = _followersDB.doc(critique.uid);
      // batch.update(
      //   followerDoc,
      //   {
      //     'lastPost': DateTime.now(),
      //     'recentPosts': FieldValue.arrayUnion(
      //       [
      //         critique.id,
      //       ],
      //     )
      //   },
      // );

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
      // Query query = _critiquesDB;

      // if (safe != null) {
      //   query = query.where('safe', isEqualTo: safe);
      // }

      // QuerySnapshot querySnapshot = await query.get();

      // List<CritiqueModel> critiques = querySnapshot.docs
      //     .map(
      //       (DocumentSnapshot documentSnapshot) =>
      //           CritiqueModel.extractDocument(ds: documentSnapshot),
      //     )
      //     .toList();

      // return critiques;
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
      await _critiquesDB.doc(critiqueID).update(data);
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
    // try {
    //   DocumentSnapshot documentSnapshot =
    //       (await _critiquesDB.doc(critiqueID).get());

    //   return CritiqueModel.extractDocument(ds: documentSnapshot);
    // } catch (e) {
    //   throw Exception(
    //     e.toString(),
    //   );
    // }
  }

  @override
  Future<List<CritiqueModel>> retrieveCritiquesForUser(
      {@required String userID}) async {
    try {
      // Query query = _critiquesDB.where('userID', isEqualTo: userID);

      // QuerySnapshot querySnapshot = await query.get();

      // List<CritiqueModel> critiques = querySnapshot.docs
      //     .map(
      //       (DocumentSnapshot documentSnapshot) =>
      //           CritiqueModel.extractDocument(ds: documentSnapshot),
      //     )
      //     .toList();

      // return critiques;
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
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.delete(
        _critiquesDB.doc(critiqueID),
      );

      batch.update(
        _dataDB.doc('tableCounts'),
        {
          'critiques': FieldValue.increment(-1),
        },
      );

      batch.update(
        _followersDB.doc(userID),
        {
          'recentPosts': FieldValue.arrayRemove(
            [
              critiqueID,
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
}
