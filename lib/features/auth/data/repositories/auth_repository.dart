import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ink_front/core/dio_client.dart';
import 'package:ink_front/core/token_provider.dart';
import 'package:ink_front/features/auth/model/user_model.dart';
import 'package:ink_front/shared/others/custom_print.dart';

class AuthRepository implements TokenProvider {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  late DioClient _client;

  AuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _client = DioClient(tokenProvider: this);
  }

  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String? name,
    required String? phone,
  }) async {
    UserCredential userAuth = await _createAuth(email, password);

    final user = UserModel(
      uid: userAuth.user!.uid,
      email: email,
      name: name,
      phone: phone,
      password: password,
    );

    try {
      await saveUserData(user);
    } on Exception catch (e) {
      CustomPrint.call(
        'Erro ao salvar dados do usuário no Firestore: $e',
        level: LogLevel.error,
      );
      await userAuth.user!.delete();
    }

    return user;
  }

  Future<UserCredential> _createAuth(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception catch (e) {
      CustomPrint.call(
        'Erro ao criar autenticação do usuário: $e',
        level: LogLevel.error,
      );
      rethrow;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        "/loginUser",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data == null) {
        throw Exception('Login failed: No data returned');
      } else if (response.data is! Map<String, dynamic>) {
        throw Exception('Login failed: ${response.data['error']}');
      }

      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on Exception {
      rethrow;
    }
  }

  Future<void> saveUserData(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJsonToFireStore())
        .onError((error, stackTrace) =>
            throw Exception('Error saving user data: $error'));
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      return doc.data();
    }

    return null;
  }

  @override
  Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }
}
