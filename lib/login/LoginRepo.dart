import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRepo {
  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
