import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/movie_model.dart';
import 'package:critic/models/user_model.dart';

//TODO: Create watchlist service and move logic from here to that file.
abstract class IUserService {
  Future<void> createUser({required UserModel user});

  Future<UserModel> retrieveUser({required String uid});

  Future<List<UserModel>> retrieveUsers(
      {required int? limit, required String? orderBy});

  Stream<QuerySnapshot> streamUsers();

  Future<void> updateUser(
      {required String uid, required Map<String, dynamic> data});

  Future<void> addMovieToWatchList({
    required String uid,
    required String imdbID,
  });

  Future<void> removeMovieFromWatchList({
    required String uid,
    required String imdbID,
  });

  Future<bool> watchListHasMovie({
    required String uid,
    required String imdbID,
  });

  Future<List<MovieModel>> listMoviesFromWatchList({
    required String uid,
  });

  Future<int> getTotalUserCount();
}

class UserService extends IUserService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');

  @override
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

  @override
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

  @override
  Stream<QuerySnapshot> streamUsers() {
    Query query = _usersDB;
    return query.snapshots();
  }

  @override
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

  @override
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

  @override
  Future<void> addMovieToWatchList({
    required String uid,
    required String imdbID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      await userDocRef.update({
        'watchList': FieldValue.arrayUnion([imdbID])
      });
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> removeMovieFromWatchList({
    required String uid,
    required String imdbID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      await userDocRef.update({
        'watchList': FieldValue.arrayRemove([imdbID])
      });
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<bool> watchListHasMovie({
    required String uid,
    required String imdbID,
  }) async {
    try {
      final DocumentReference userDocRef = _usersDB.doc(uid);

      DocumentSnapshot<Object?> userData = (await userDocRef.get());

      Object object = userData.data()!;

      //TODO: Return true if the imdbID is contained in the users wqtchList array...

      return true;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<MovieModel>> listMoviesFromWatchList({
    required String uid,
  }) async {
    try {
      //TODO: List each movie out.
      final DocumentReference userDocRef = _usersDB.doc(uid);

      // final CollectionReference watchListColRef =
      //     userDocRef.collection('watchList');
      // Query query = watchListColRef.orderBy(
      //   'addedToWatchList',
      //   descending: true,
      // );
      //
      // List<MovieModel> movies = (await query.get())
      //     .docs
      //     .map((e) => MovieModel.fromDoc(data: e))
      //     .toList();
      //
      // return movies;
      return [];
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

      int userCount = tableCountsDocSnap['users'] as int;

      return userCount;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
