import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IFollowerService {
  void follow({
    @required String followed,
    @required String follower,
  });

  void unfollow({
    @required String followed,
    @required String follower,
  });

  Future<bool> followerAisFollowingUserB({
    @required String userAID,
    @required String userBID,
  });

  Future<List<String>> getCritiqueIDSForFeed({
    @required String userID,
  });

  Future<List<String>> getFollowersIDS({@required String userID});
  Future<List<String>> getFollowingsIDS({@required String userID});

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

class FollowerService extends IFollowerService {
  final CollectionReference _critiquesDB =
      FirebaseFirestore.instance.collection('Critiques');
  final CollectionReference _dataDB =
      FirebaseFirestore.instance.collection('Data');
  final CollectionReference _followersDB =
      FirebaseFirestore.instance.collection('Followers');

  @override
  void follow({
    @required String followed,
    @required String follower,
  }) {
    final DocumentReference followersRef = _followersDB.doc(followed);
    followersRef.update(
      {
        'users': FieldValue.arrayUnion(
          [
            follower,
          ],
        )
      },
    );
  }

  @override
  void unfollow({
    @required String followed,
    @required String follower,
  }) {
    final DocumentReference followersRef = _followersDB.doc(followed);
    followersRef.update(
      {
        'users': FieldValue.arrayRemove(
          [
            follower,
          ],
        )
      },
    );
  }

  @override
  Future<List<String>> getCritiqueIDSForFeed({
    @required String userID,
  }) async {
    final QuerySnapshot followedUsers = await _followersDB
        .where(
          'users',
          arrayContains: userID,
        )
        .get();

    List<String> critiqueIDs = List<String>();

    for (var i = 0; i < followedUsers.docs.length; i++) {
      for (var j = 0;
          j < followedUsers.docs[i].data()['recentPosts'].length;
          j++) {
        final String critiqueID =
            followedUsers.docs[i].data()['recentPosts'][j] as String;
        critiqueIDs.add(critiqueID);
      }
    }

    return critiqueIDs;
  }

  @override
  Future<bool> followerAisFollowingUserB({
    @required String userAID,
    @required String userBID,
  }) async {
    final DocumentSnapshot followersRef = await _followersDB.doc(userBID).get();
    final List<dynamic> followers = followersRef.data()['users'];
    return followers.contains(userAID);
  }

  @override
  Future<List<String>> getFollowersIDS({
    @required String userID,
  }) async {
    DocumentSnapshot followerDocSnapshot = await _followersDB.doc(userID).get();

    dynamic followersIDS = followerDocSnapshot.data()['users'];

    List<String> followersIDs = List<String>();

    for (dynamic followersID in followersIDS) {
      followersIDs.add(followersID);
    }

    return followersIDs;
  }

  @override
  Future<List<String>> getFollowingsIDS({
    @required String userID,
  }) async {
    final QuerySnapshot followedUsers = await _followersDB
        .where(
          'users',
          arrayContains: userID,
        )
        .get();

    List<String> followingsIDs =
        followedUsers.docs.map((DocumentSnapshot doc) => doc.id).toList();

    return followingsIDs;
  }

  @override
  void block({
    @required String blockerID,
    @required String blockeeID,
  }) async {
    final DocumentReference docRef = _followersDB.doc(blockerID);
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
    final DocumentReference docRef = _followersDB.doc(blockerID);
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
    DocumentSnapshot followerDocSnapshot = await _followersDB.doc(userID).get();

    dynamic blockedUsers = followerDocSnapshot.data()['blockedUsers'];

    List<String> blockedUsersIDS = List<String>();

    for (dynamic blockedUserID in blockedUsers) {
      blockedUsersIDS.add(blockedUserID);
    }

    return blockedUsersIDS;
  }

  @override
  Future<List<String>> getUsersWhoBlockedMeIDs(
      {@required String userID}) async {
    final QuerySnapshot usersWhoBlockedMe = await _followersDB
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
