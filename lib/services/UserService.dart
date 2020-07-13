import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';

abstract class IUserService {
  //Users
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String uid});
  Future<List<UserModel>> retrieveAllUsers();
  Stream<QuerySnapshot> streamUsers();
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data});
}

class UserService extends IUserService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final CollectionReference _dataDB = Firestore.instance.collection('Data');
  final CollectionReference _followersDB =
      Firestore.instance.collection('Followers');

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      final WriteBatch batch = Firestore.instance.batch();

      final DocumentReference userDocRef = _usersDB.document(user.uid);
      batch.setData(
        userDocRef,
        user.toMap(),
      );

      final DocumentReference tableCountsDocRef =
          _dataDB.document('tableCounts');
      batch.updateData(tableCountsDocRef, {'users': FieldValue.increment(1)});

      final DocumentReference followerDocRef = _followersDB.document(user.uid);
      batch.setData(followerDocRef, {
        'lastPost': null,
        'recentPosts': [],
        'users': [],
        'blockedUsers': [],
      });

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
      DocumentSnapshot documentSnapshot = await _usersDB.document(uid).get();
      return UserModel.extractDocument(ds: documentSnapshot);
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
      await _usersDB.document(uid).updateData(data);
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
      return (await _usersDB.getDocuments())
          .documents
          .map((doc) => UserModel.extractDocument(ds: doc))
          .toList();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
