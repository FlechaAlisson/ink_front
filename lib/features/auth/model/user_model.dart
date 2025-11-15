class UserModel {
  final String uid;
  final String email;
  final String password;
  final String? name;
  final String? phone;

  // Tokens opcionais
  final String? idToken;
  final String? refreshToken;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    this.name,
    this.phone,
    this.idToken,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return UserModel(
      uid: user['uid'],
      email: user['email'],
      password:
          '', // não vem no JSON (você decide se ignora ou armazena depois)
      name: user['name'],
      phone: user['phone'],
      idToken: json['tokens']?['idToken'],
      refreshToken: json['tokens']?['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'idToken': idToken,
      'refreshToken': refreshToken,
    };
  }

  Map<String, dynamic> toJsonToFireStore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? idToken,
    String? refreshToken,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      idToken: idToken ?? this.idToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
