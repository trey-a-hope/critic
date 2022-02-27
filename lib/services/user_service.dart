import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/user_model.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  /// Users collection reference.
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');

  /// Data collection reference.
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('data');

  /// Create a user.
  Future<void> createUser({required UserModel user}) async {
    try {
      // Create batch instance.
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      // Create document reference of user.
      final DocumentReference userDocRef = _usersDB.doc(user.uid);

      // Set the user data to the document reference.
      batch.set(
        userDocRef,
        user.toJson(),
      );

      // Create document reference of tableCounts.
      final DocumentReference tableCountsDocRef = _dataDB.doc('tableCounts');

      // Update the user account on the table counts document.
      batch.update(tableCountsDocRef, {'users': FieldValue.increment(1)});

      // Execute batch.
      await batch.commit();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// Retrieve a user.
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

  /// Update a user.
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

  /// Retrieve users.
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

  /// Get total user count.
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
