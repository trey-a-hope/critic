import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');

  Future<void> createUser({required UserModel user}) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final DocumentReference userDocRef = _usersDB.doc(user.uid);

      Map userMap = user.toJson();
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

  Future<UserModel> retrieveUser({required String uid}) async {
    try {
      final DocumentReference model = await _usersDB
          .doc(uid)
          .withConverter<UserModel>(
              fromFirestore: (snapshot, _) =>
                  UserModel.fromJson(snapshot.data()!),
              toFirestore: (model, _) => model.toJson());

      return (await model.get()).data() as UserModel;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot> streamUsers() {
    Query query = _usersDB;
    return query.snapshots();
  }

  Future<void> updateUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['modified'] = DateTime.now();
      await _usersDB.doc(uid).update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<List<UserModel>> retrieveUsers(
      {required int? limit, required String? orderBy}) async {
    try {
      Query query = _usersDB;

      if (limit != null) {
        query = query.limit(limit);
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: true);
      }

      List<Future<DocumentSnapshot<UserModel>>> s = (await query.get())
          .docs
          .map((doc) => (doc.reference
              .withConverter<UserModel>(
                  fromFirestore: (snapshot, _) =>
                      UserModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .get()))
          .toList();

      List<UserModel> users = [];

      for (int i = 0; i < s.length; i++) {
        DocumentSnapshot<UserModel> res = await s[i];
        users.add(res.data()!);
      }

      return users;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<int> getTotalUserCount() async {
    try {
      DocumentSnapshot tableCountsDocSnap =
          await _dataDB.doc('tableCounts').get();

      int userCount = tableCountsDocSnap['users'] as int;

      return userCount;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
