// ignore_for_file: file_names, unused_catch_clause

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/Utils/Constants.dart';
import '../Utente.dart';
import 'package:get/get.dart';

class GestoreAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  GestoreAuth._privateConstructor();

  static final instance = GestoreAuth._privateConstructor();

  Future<String?> login(String email, String password) async {
    try {
       await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
       return "ok";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<UserCredential?> registrazione(String email, String password) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
