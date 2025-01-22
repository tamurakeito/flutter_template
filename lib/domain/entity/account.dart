class Account {
  final int id;
  final String userId;
  final String password;
  final String name;

  Account({
    required this.id,
    required this.userId,
    required this.password,
    required this.name,
  });
}

class SignInRequest {
  final String userId;
  final String password;

  SignInRequest({
    required this.userId,
    required this.password,
  });

  factory SignInRequest.fromJson(Map<String, dynamic> json) {
    return SignInRequest(
      userId: json['user_id'] as String,
      password: json['password'] as String,
    );
  }
}

class SignInResponse {
  final int id;
  final String userId;
  final String name;
  final String token;

  SignInResponse({
    required this.id,
    required this.userId,
    required this.name,
    required this.token,
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

class SignUpRequest {
  final String userId;
  final String password;
  final String name;

  SignUpRequest({
    required this.userId,
    required this.password,
    required this.name,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      userId: json['user_id'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );
  }
}

class SignUpResponse {
  final int id;
  final String userId;
  final String name;
  final String token;

  SignUpResponse({
    required this.id,
    required this.userId,
    required this.name,
    required this.token,
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
