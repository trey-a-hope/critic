import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/Constants.dart';
import 'package:critic/models/CommentModel.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class ICritiqueService {
  Future<void> createCritique({@required CritiqueModel critique});
  Future<List<CritiqueModel>> retrieveCritiquesFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  });
  Future<List<DocumentSnapshot>> retrieveCritiquesFromFirebase({
    @required String uid,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  });
  Future<void> deleteCritique({
    @required String critiqueID,
    @required String uid,
  });

  Future<void> followUser({
    @required String myUID,
    @required String theirUID,
  });

  Future<void> unfollowUser({
    @required String myUID,
    @required String theirUID,
  });

  Future<bool> isFollowing({
    @required String myUID,
    @required String theirUID,
  });

  Future<dynamic> followStats({
    @required String uid,
  });

  Future<void> createComment({
    @required String critiqueID,
    @required CommentModel comment,
  });

  Future<void> deleteComment({
    @required String critiqueID,
    @required String commentID,
  });

  Future<List<DocumentSnapshot>> retrieveCommentsFromFirebase({
    @required String critiqueID,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  });
}

class CritiqueService extends ICritiqueService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _critiquesDB =
      FirebaseFirestore.instance.collection('Critiques');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');

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

      Map firebaseMap = critique.toJson();

      firebaseMap['commentCount'] = 0;
      firebaseMap['likeCount'] = 0;
      firebaseMap['likes'] = [];
      firebaseMap['id'] = critiqueID;
      firebaseMap['created'] = DateTime.now();

      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);

      batch.set(
        critiqueDocRef,
        firebaseMap,
      );

      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');
      batch.update(
        tableCountsDocRef,
        {
          'critiques': FieldValue.increment(1),
        },
      );

      final DocumentReference userDocRef = _usersDB.doc(critique.uid);
      batch.update(
        userDocRef,
        {
          'critiqueCount': FieldValue.increment(1),
        },
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
      batch.delete(
        critiqueDocRef,
      );
      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');

      batch.update(
        tableCountsDocRef,
        {
          'critiques': FieldValue.increment(-1),
        },
      );

      final DocumentReference userDocRef = _usersDB.doc(uid);
      batch.update(
        userDocRef,
        {
          'critiqueCount': FieldValue.increment(-1),
        },
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
  Future<List<DocumentSnapshot>> retrieveCritiquesFromFirebase({
    @required String uid,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  }) async {
    try {
      Query query = _critiquesDB.orderBy('created', descending: true);

      if (uid != null) {
        query = query.where('uid', isEqualTo: uid);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      List<DocumentSnapshot> documentSnapshots = (await query.get()).docs;

      return documentSnapshots;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> followUser(
      {@required String myUID, @required String theirUID}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}FollowUserFeed',
        body: {
          'myUID': myUID,
          'theirUID': theirUID,
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
      return;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<void> unfollowUser({
    @required String myUID,
    @required String theirUID,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}UnfollowUserFeed',
        body: {
          'myUID': myUID,
          'theirUID': theirUID,
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

      return;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<bool> isFollowing({
    @required String myUID,
    @required String theirUID,
  }) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}IsFollowing',
        body: {
          'myUID': myUID,
          'theirUID': theirUID,
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

      final List<dynamic> results = map['results'];

      return results.length > 0;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<dynamic> followStats({@required String uid}) async {
    try {
      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}GetFollowStats',
        body: {
          'uid': uid,
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

      final List<dynamic> results = map['results'];

      return results.length > 0;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<void> createComment({
    @required String critiqueID,
    @required CommentModel comment,
  }) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);

      final DocumentReference commentDocRef =
          critiqueDocRef.collection('comments').doc();
      comment.id = commentDocRef.id;

      batch.set(
        commentDocRef,
        comment.toMap(),
      );

      batch.update(
        critiqueDocRef,
        {
          'commentCount': FieldValue.increment(1),
        },
      );

      await batch.commit();
      return;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<void> deleteComment(
      {@required String critiqueID, @required String commentID}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);

      final DocumentReference commentDocRef =
          critiqueDocRef.collection('comments').doc(commentID);

      batch.delete(commentDocRef);

      batch.update(
        critiqueDocRef,
        {
          'commentCount': FieldValue.increment(-1),
        },
      );

      await batch.commit();
      return;
    } catch (error) {
      throw Exception(
        error.toString(),
      );
    }
  }

  @override
  Future<List<DocumentSnapshot>> retrieveCommentsFromFirebase({
    @required String critiqueID,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  }) async {
    try {
      final DocumentReference critiqueDocRef = _critiquesDB.doc(critiqueID);

      CollectionReference commentsColRef =
          critiqueDocRef.collection('comments');

      Query query = commentsColRef.orderBy('created', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      List<DocumentSnapshot> documentSnapshots = (await query.get()).docs;

      return documentSnapshots;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
