import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/UserModel.dart';
import 'package:flutter/material.dart';

abstract class IUsersService {
  //Users
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String id});
  // Future<List<UserModel>> retrieveUsers(
  //     {bool isAdmin, int limit, String orderBy});
  Stream<QuerySnapshot> streamUsers();
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data});
}

class UsersService extends IUsersService {
  final CollectionReference usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> createUser({UserModel user}) async {
    try {
      DocumentReference docRef = usersDB.document();
      user.id = docRef.documentID;
      docRef.setData(user.toMap());
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await usersDB.document(id).get();
      return UserModel.extractDocument(documentSnapshot: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<QuerySnapshot> streamUsers() {
    Query query = usersDB; 
    return query.snapshots();
  }

  @override
  Future<void> updateUser({String userID, Map<String, dynamic> data}) async {
    try {
      await usersDB.document(userID).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // @override
  // Future<List<UserModel>> retrieveUsers(
  //     {bool isAdmin, int limit, String orderBy}) async {
  //   try {
  //     Query query = usersDB;

  //     if (isAdmin != null) {
  //       query = query.where('isAdmin', isEqualTo: isAdmin);
  //     }

  //     if (limit != null) {
  //       query = query.limit(limit);
  //     }

  //     if (orderBy != null) {
  //       query = query.orderBy(orderBy);
  //     }

  //     List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
  //     List<UserModel> users = List<UserModel>();
  //     for (int i = 0; i < docs.length; i++) {
  //       users.add(
  //         UserModel.extractDocument(docs[i]),
  //       );
  //     }

  //     return users;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

}
