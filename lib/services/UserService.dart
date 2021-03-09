import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/Constants.dart';
import 'package:critic/models/MovieModel.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

//TODO: Create watchlist service and move logic from here to that file.
abstract class IUserService {
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String uid});
  Future<List<UserModel>> retrieveUsers({int limit, String orderBy});
  Stream<QuerySnapshot> streamUsers();
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data});
  Future<List<UserModel>> retrieveFollowersFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  });

  Future<List<UserModel>> retrieveFollowingsFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  });

  Future<void> addMovieToWatchList({
    @required String uid,
    @required MovieModel movie,
  });

  Future<void> removeMovieFromWatchList({
    @required String uid,
    @required String imdbID,
  });

  Future<bool> watchListHasMovie({
    @required String uid,
    @required String imdbID,
  });

  Future<List<DocumentSnapshot>> retrieveMoviesFromWatchlist({
    @required String uid,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  });

  Future<Stream<QuerySnapshot>> streamMoviesFromWatchlist({
    @required String uid,
  });

  Future<int> getTotalUserCount();
}

class UserService extends IUserService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersDB.doc(user.uid);

      Map userMap = user.toMap();
      userMap['blockedUsers'] = [];

      batch.set(
        userDocRef,
        userMap,
      );

      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');
      batch.update(tableCountsDocRef, {'users': FieldValue.increment(1)});

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({@required String uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.doc(uid).get();
      return UserModel.fromDoc(ds: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<QuerySnapshot> streamUsers() {
    Query query = _usersDB;
    return query.snapshots();
  }

  @override
  Future<void> updateUser(
      {@required String uid, Map<String, dynamic> data}) async {
    try {
      await _usersDB.doc(uid).update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveUsers({int limit, String orderBy}) async {
    try {
      Query query = _usersDB;

      if (limit != null) {
        query = query.limit(limit);
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: true);
      }

      return (await query.get())
          .docs
          .map((doc) => UserModel.fromDoc(ds: doc))
          .toList();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveFollowersFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  }) async {
    try {
      Map data = {
        'uid': uid,
        'limit': '$limit',
        'offset': '$offset',
      };

      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}GetUsersFollowers',
        body: data,
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      );

      Map map = json.decode(response.body);

      if (map['statusCode'] != null) {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }

      final List<dynamic> results = map['results'];

      List<UserModel> users = [];

      for (int i = 0; i < results.length; i++) {
        dynamic result = results[i];

        final String uid = result['feed_id'].replaceAll('Critiques:', '');

        final UserModel user = await retrieveUser(uid: uid);

        print(uid);

        users.add(user);
      }

      return users;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveFollowingsFromStream({
    @required String uid,
    @required int limit,
    @required int offset,
  }) async {
    try {
      Map data = {
        'uid': uid,
        'limit': '$limit',
        'offset': '$offset',
      };

      http.Response response = await http.post(
        '${CLOUD_FUNCTIONS_ENDPOINT}GetUsersFollowees',
        body: data,
        headers: {'content-type': 'application/x-www-form-urlencoded'},
      );

      Map map = json.decode(response.body);

      if (map['statusCode'] != null) {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }

      final List<dynamic> results = map['results'];

      List<UserModel> users = [];

      for (int i = 0; i < results.length; i++) {
        dynamic result = results[i];

        final String uid = result['target_id'].replaceAll('Critiques:', '');

        final UserModel user = await retrieveUser(uid: uid);

        print(uid);

        users.add(user);
      }

      return users;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> addMovieToWatchList({
    @required String uid,
    @required MovieModel movie,
  }) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference watchListColRef =
          userDocRef.collection('watchList');

      final DocumentReference watchListDocRef = watchListColRef.doc();

      movie.addedToWatchList = DateTime.now();

      batch.set(
        watchListDocRef,
        movie.toMap(),
      );

      batch.update(userDocRef, {'watchListCount': FieldValue.increment(1)});

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> removeMovieFromWatchList({
    @required String uid,
    @required String imdbID,
  }) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference watchListColRef =
          userDocRef.collection('watchList');

      final List<QueryDocumentSnapshot> watchListQuerySnap =
          (await watchListColRef.where('imdbID', isEqualTo: imdbID).get()).docs;

      if (watchListQuerySnap.isEmpty) {
        return;
      }

      final DocumentReference watchListDocRef =
          watchListQuerySnap.first.reference;

      batch.delete(
        watchListDocRef,
      );

      batch.update(userDocRef, {'watchListCount': FieldValue.increment(-1)});

      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<bool> watchListHasMovie({
    @required String uid,
    @required String imdbID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference watchListColRef =
          userDocRef.collection('watchList');

      final List<QueryDocumentSnapshot> watchListQuerySnap =
          (await watchListColRef.where('imdbID', isEqualTo: imdbID).get()).docs;

      return watchListQuerySnap.isNotEmpty;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<DocumentSnapshot>> retrieveMoviesFromWatchlist({
    @required String uid,
    @required int limit,
    @required DocumentSnapshot startAfterDocument,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference watchListColRef =
          userDocRef.collection('watchList');
      Query query = watchListColRef.orderBy(
        'addedToWatchList',
        descending: true,
      );

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
  Future<Stream<QuerySnapshot>> streamMoviesFromWatchlist(
      {@required String uid}) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      final CollectionReference watchListColRef =
          userDocRef.collection('watchList');

      return watchListColRef.snapshots();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<int> getTotalUserCount() async {
    try {
      DocumentSnapshot tableCountsDocSnap =
          await _dataDB.doc('tableCounts').get();

      int userCount = tableCountsDocSnap.data()['users'] as int;

      return userCount;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
