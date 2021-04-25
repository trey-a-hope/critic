import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IBlockUserService {
  void block({
    @required String blockerID,
    @required String blockeeID,
  });

  void unblock({
    @required String blockerID,
    @required String blockeeID,
  });

  Future<List<String>> getUsersIBlockedIDs({
    @required String userID,
  });

  Future<List<String>> getUsersWhoBlockedMeIDs({
    @required String userID,
  });
}

class BlockUserService extends IBlockUserService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  @override
  void block({
    @required String blockerID,
    @required String blockeeID,
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

  @override
  void unblock({
    @required String blockerID,
    @required String blockeeID,
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

  @override
  Future<List<String>> getUsersIBlockedIDs({@required String userID}) async {
    DocumentSnapshot followerDocSnapshot = await _usersDB.doc(userID).get();

    dynamic blockedUsers = followerDocSnapshot.data()['blockedUsers'];

    List<String> blockedUsersIDS = [];

    for (dynamic blockedUserID in blockedUsers) {
      blockedUsersIDS.add(blockedUserID);
    }

    return blockedUsersIDS;
  }

  @override
  Future<List<String>> getUsersWhoBlockedMeIDs(
      {@required String userID}) async {
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
