abstract class Account {
  final int id;
  final String userId;
  final String name;
  final String token;

  Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'token': token,
    };
  }
}

class User extends Account {
  final String password;

  User({
    required super.id,
    required super.userId,
    required this.password,
    required super.name,
    required super.token,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }
}

abstract class AuthRequest {
  final String userId;
  final String password;

  AuthRequest({
    required this.userId,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'password': password,
    };
  }
}

class SignInRequest extends AuthRequest {
  SignInRequest({
    required super.userId,
    required super.password,
  });
}

class SignUpRequest extends AuthRequest {
  final String name;

  SignUpRequest({
    required super.userId,
    required super.password,
    required this.name,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
    };
  }
}

class SignInResponse extends Account {
  SignInResponse({
    required super.id,
    required super.userId,
    required super.name,
    required super.token,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }
}

class SignUpResponse extends Account {
  SignUpResponse({
    required super.id,
    required super.userId,
    required super.name,
    required super.token,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }
}
