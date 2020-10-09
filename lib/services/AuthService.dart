import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<User> onAuthStateChanged();
  Future<UserCredential> signInWithEmailAndPassword(
      {@required String email, @required String password});

  Future<UserCredential> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  void updatePassword({@required String password});
  Future<void> deleteUser({@required String userID});
}

class AuthService extends IAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersDB = FirebaseFirestore.instance.collection('Users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      User firebaseUser = auth.currentUser;
      DocumentSnapshot documentSnapshot =
          await usersDB.doc(firebaseUser.uid).get();
      return UserModel.extractDocument(ds: documentSnapshot);
    } catch (e) {
      throw Exception('Could not fetch user at this time.');
    }
  }

  @override
  Future<void> signOut() {
    return auth.signOut();
  }

  @override
  Stream<User> onAuthStateChanged() {
    return auth.authStateChanges();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  void updatePassword({String password}) async {
    try {
      User firebaseUser = auth.currentUser;
      firebaseUser.updatePassword(password);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteUser({String userID}) async {
    try {
      User firebaseUser = auth.currentUser;
      await firebaseUser.delete();
      await usersDB.doc(userID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
