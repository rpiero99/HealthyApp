// ignore_for_file: file_names, unused_catch_clause

import 'package:firebase_auth/firebase_auth.dart';
import '../Utente.dart';

class GestoreAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  GestoreAuth._privateConstructor();
  static final instance = GestoreAuth._privateConstructor();

  Future<UserCredential?> login(Utente utente) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: utente.email as String,
        password: utente.password as String,
      );
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<UserCredential?> registrazione(Utente utente) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(
        email: utente.email as String,
        password: utente.password as String,
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
