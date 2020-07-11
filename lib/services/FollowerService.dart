import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/ServiceLocator.dart';
import 'package:critic/models/CritiqueModel.dart';
import 'package:critic/models/UserModel.dart';
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
      Firestore.instance.collection('Critiques');
  final CollectionReference _dataDB = Firestore.instance.collection('Data');
  final CollectionReference _followersDB =
      Firestore.instance.collection('Followers');

  @override
  void follow({
    @required String followed,
    @required String follower,
  }) {
    final DocumentReference followersRef = _followersDB.document(followed);
    followersRef.updateData(
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
    final DocumentReference followersRef = _followersDB.document(followed);
    followersRef.updateData(
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
        .getDocuments();

    List<String> critiqueIDs = List<String>();

    for (var i = 0; i < followedUsers.documents.length; i++) {
      for (var j = 0;
          j < followedUsers.documents[i].data['recentPosts'].length;
          j++) {
        final String critiqueID =
            followedUsers.documents[i].data['recentPosts'][j] as String;
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
    final DocumentSnapshot followersRef =
        await _followersDB.document(userBID).get();
    final List<dynamic> followers = followersRef.data['users'];
    return followers.contains(userAID);
  }

  @override
  Future<List<String>> getFollowersIDS({
    @required String userID,
  }) async {
    DocumentSnapshot followerDocSnapshot =
        await _followersDB.document(userID).get();

    dynamic followersIDS = followerDocSnapshot.data['users'];

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
        .getDocuments();

    List<String> followingsIDs = followedUsers.documents
        .map((DocumentSnapshot doc) => doc.documentID)
        .toList();

    return followingsIDs;
  }

  @override
  void block({
    @required String blockerID,
    @required String blockeeID,
  }) async {
    final DocumentReference docRef = _followersDB.document(blockerID);
    docRef.updateData({
      'blockedUsers': FieldValue.arrayUnion(
        [
          blockeeID,
        ],
      )
    });
    return;
  }

  @override
  void unblock({
    @required String blockerID,
    @required String blockeeID,
  }) async {
    final DocumentReference docRef = _followersDB.document(blockerID);
    docRef.updateData({
      'blockedUsers': FieldValue.arrayRemove(
        [
          blockeeID,
        ],
      )
    });
    return;
  }

  @override
  Future<List<String>> getUsersIBlockedIDs({@required String userID}) async {
    DocumentSnapshot followerDocSnapshot =
        await _followersDB.document(userID).get();

    dynamic blockedUsers = followerDocSnapshot.data['blockedUsers'];

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
        .getDocuments();

    List<String> usersWhoBlockedMeIDs = usersWhoBlockedMe.documents
        .map((DocumentSnapshot doc) => doc.documentID)
        .toList();

    return usersWhoBlockedMeIDs;
  }
}
