import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ink_front/features/auth/model/user_model.dart';

class FirebaseAuthDataSource {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel> register(UserModel user, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    final uid = cred.user!.uid;

    final newUser = user.copyWith(uid: uid);

    await _firestore.collection("users").doc(uid).set(newUser.toJson());

    return newUser;
  }

  Future<UserModel> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    final doc = await _firestore.collection("users").doc(uid).get();

    return UserModel.fromJson(doc.data()!);
  }
}
