import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailandPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // _firestore.collection('users').doc(userCredential.user!.uid).set({
      //   'uid': userCredential.user!.uid,
      //   'email': userCredential.user!.email,
      //   'phone': '84957777777',
      //   'name': 'Иван',
      //   'surname': 'Иванов',
      //   'patronymic': 'Иванович',
      //   'position': 'Генеральный секретарь ЦК IQJ',
      //   'institute': 'ИПТИП',
      //   'role': 'student',
      // });

      // Использовать это в методе для регистрации когда он понадобится (написать тоже нужно)
      // _firestore.collection('users').doc(userCredential.user!.uid).set({
      //   'uid': userCredential.user!.uid,
      //   'email': userCredential.user!.email,
      // }), SetOptions(merge: true);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'phone': '84957777777',
        'name': 'Иван',
        'surname': 'Иванов',
        'patronymic': 'Иванович',
        'position': 'Генеральный секретарь ЦК IQJ',
        'institute': 'ИПТИП',
        'role': 'student',
        'picture': 'https://cdn.discordapp.com/attachments/1227328511396810853/1239910152652587008/image.png?ex=6644a3d0&is=66435250&hm=13e5569c737c9cd06259656916ed42fe39e7be33fdf76f049297dfb3446cc7d8&',
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
