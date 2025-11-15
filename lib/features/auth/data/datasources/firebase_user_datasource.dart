import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ink_front/features/auth/model/user_model.dart';

class FirebaseUserDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Registrar usuário no Firebase Auth + criar documento no Firestore
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String? name,
    required String? phone,
  }) async {
    // 1. Cria no Firebase Auth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 2. Monta o userModel
    final user = UserModel(
        uid: uid, email: email, name: name, phone: phone, password: password);

    // 3. Salva no Firestore
    await _firestore.collection("users").doc(uid).set(user.toJson());

    return user;
  }

  /// Fazer login e buscar o perfil do Firestore
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    // 1. Login no Firebase Auth
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 2. Buscar dados complementares no Firestore
    final doc = await _firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      throw Exception("Perfil de usuário não encontrado no Firestore.");
    }

    return UserModel.fromJson(doc.data()!);
  }

  /// Buscar dados do usuário logado
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await _firestore.collection("users").doc(user.uid).get();

    if (!doc.exists) return null;

    return UserModel.fromJson(doc.data()!);
  }

  /// Deslogar usuário
  Future<void> logout() async {
    await _auth.signOut();
  }
}
