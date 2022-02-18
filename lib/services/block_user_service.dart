import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BlockUserService extends GetxService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  void block({
    required String blockerID,
    required String blockeeID,
  }) async {
    final DocumentReference docRef = _usersDB.doc(blockerID);
    docRef.update(
      {
        'blockedUsers': FieldValue.arrayUnion(
          [
            blockeeID,
          ],
        )
      },
    );
    return;
  }

  void unblock({
    required String blockerID,
    required String blockeeID,
  }) async {
    final DocumentReference docRef = _usersDB.doc(blockerID);
    docRef.update(
      {
        'blockedUsers': FieldValue.arrayRemove(
          [
            blockeeID,
          ],
        )
      },
    );
    return;
  }

  Future<List<String>> getUsersIBlockedIDs({required String userID}) async {
    DocumentSnapshot followerDocSnapshot = await _usersDB.doc(userID).get();

    dynamic blockedUsers = followerDocSnapshot['blockedUsers'];

    List<String> blockedUsersIDS = [];

    for (dynamic blockedUserID in blockedUsers) {
      blockedUsersIDS.add(blockedUserID);
    }

    return blockedUsersIDS;
  }

  Future<List<String>> getUsersWhoBlockedMeIDs({required String userID}) async {
    final QuerySnapshot usersWhoBlockedMe = await _usersDB
        .where(
          'blockedUsers',
          arrayContains: userID,
        )
        .get();

    List<String> usersWhoBlockedMeIDs =
        usersWhoBlockedMe.docs.map((DocumentSnapshot doc) => doc.id).toList();

    return usersWhoBlockedMeIDs;
  }
}
