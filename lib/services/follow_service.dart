import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/data/user_model.dart';

class FollowService extends GetxService {
  /// Users database collection reference.
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');

  /// User A follows user B.
  Future<void> followAtoB({
    required String userAuid,
    required String userBuid,
  }) async {
    try {
      // Create batch write.
      WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      // Get the document reference for user A.
      final DocumentReference userADocRef = _usersDB.doc(userAuid);

      // Get the document reference for user B.
      final DocumentReference userBDocRef = _usersDB.doc(userBuid);

      // Add user B uid to user A followings array.
      writeBatch.update(userADocRef, {
        'followings': FieldValue.arrayUnion([userBuid])
      });

      // Add user A uid to user B followers array.
      writeBatch.update(userBDocRef, {
        'followers': FieldValue.arrayUnion([userAuid])
      });

      writeBatch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// User A unfollows user B.
  Future<void> unfollowAtoB({
    required String userAuid,
    required String userBuid,
  }) async {
    try {
      // Create batch write.
      WriteBatch writeBatch = FirebaseFirestore.instance.batch();

      // Get the document reference for user A.
      final DocumentReference userADocRef = _usersDB.doc(userAuid);

      // Get the document reference for user B.
      final DocumentReference userBDocRef = _usersDB.doc(userBuid);

      // Remove user B uid to user A followings array.
      writeBatch.update(userADocRef, {
        'followings': FieldValue.arrayRemove([userBuid])
      });

      // Remove user A uid to user B followers array.
      writeBatch.update(userBDocRef, {
        'followers': FieldValue.arrayRemove([userAuid])
      });

      writeBatch.commit();

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  /// User A is following user B.
  Future<bool> AisFollowingB({
    required String userAuid,
    required String userBuid,
  }) async {
    try {
      // Get the document reference for user B.
      final DocumentReference userBDocRef = _usersDB.doc(userBuid);

      // Get user B as user object.
      UserModel userB = (await (await userBDocRef.get())
              .reference
              .withConverter<UserModel>(
                  fromFirestore: (snapshot, _) =>
                      UserModel.fromJson(snapshot.data()!),
                  toFirestore: (model, _) => model.toJson())
              .get())
          .data() as UserModel;

      /// Check to see if user A uid  is in user B's followers list.
      if (userB.followers.contains(userAuid)) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
