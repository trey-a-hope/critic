import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:critic/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<FirebaseUser> onAuthStateChanged();
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password});

  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password});
  Future<void> updatePassword({@required String password});
  Future<void> deleteUser({@required String userID});
}

class AuthService extends IAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersDB = Firestore.instance.collection('Users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await auth.currentUser();
      DocumentSnapshot documentSnapshot =
          await usersDB.document(firebaseUser.uid).get();
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
  Stream<FirebaseUser> onAuthStateChanged() {
    return auth.onAuthStateChanged;
  }

  @override
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> updatePassword({String password}) async {
    try {
      FirebaseUser firebaseUser = await auth.currentUser();
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
      FirebaseUser firebaseUser = await auth.currentUser();
      await firebaseUser.delete();
      await usersDB.document(userID).delete();
      //TODO: DELETE STRIPE ACCOUNT
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
