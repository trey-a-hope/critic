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

    Iterable<Map<String, dynamic>> followedUsersData =
        followedUsers.documents.map((doc) => doc.data);

    if (followedUsersData.isEmpty) return [];

    List<String> critiqueIDs = List<String>();

    for (Map<String, dynamic> followedUserData in followedUsersData) {
      for (Map<String, dynamic> recentPostsMap
          in followedUserData['recentPosts']) {
        critiqueIDs.add(
          recentPostsMap['id'],
        );
      }
    }

    return critiqueIDs;
  }

  @override
  Future<bool> followerAisFollowingUserB(
      {@required String userAID, @required String userBID}) async {
    final DocumentSnapshot followersRef =
        await _followersDB.document(userBID).get();
    final List<dynamic> followers = followersRef.data['users'];
    return followers.contains(userAID);
  }
}
