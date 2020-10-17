import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/Constants.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class IUserService {
  //Users
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String uid});
  Future<List<UserModel>> retrieveAllUsers();
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
  Future<List<UserModel>> retrieveAllUsers() async {
    try {
      return (await _usersDB.get())
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

      List<UserModel> users = List<UserModel>();

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

      List<UserModel> users = List<UserModel>();

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
}
