class UserModel {
  final int idUser;
  final String nameUser;
  final String? email;
  final String? typeUser;
  final String? typeOpen;

  UserModel({
    required this.idUser,
    required this.nameUser,
    this.email,
    this.typeUser,
    this.typeOpen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['idUser'],
      nameUser: json['nameUser'],
      email: json['email'],
      typeUser: json['typeUser'],
      typeOpen: json['typeOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'nameUser': nameUser,
      'email': email,
      'typeUser': typeUser,
      'typeOpen': typeOpen,
    };
  }
}

class SignInDto {
  final String nameUser;
  final String password;

  SignInDto({
    required this.nameUser,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameuser': nameUser,
      'password': password,
    };
  }
}