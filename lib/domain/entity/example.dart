class Hello {
  final int id;
  final String name;
  final bool tag;

  Hello({
    required this.id,
    required this.name,
    required this.tag,
  });

  // fromJson メソッドの定義
  factory Hello.fromJson(Map<String, dynamic> json) {
    return Hello(
      id: json['id'] as int,
      name: json['name'] as String,
      tag: json['tag'] as bool,
    );
  }
}

class HelloWorld {
  final int id;
  final Hello hello;

  HelloWorld({
    required this.id,
    required this.hello,
  });

  // fromJson メソッドの定義
  factory HelloWorld.fromJson(Map<String, dynamic> json) {
    return HelloWorld(
      id: json['id'] as int,
      hello: Hello.fromJson(json['hello'] as Map<String, dynamic>),
    );
  }
}
