class Hello {
  final int id;
  final String name;
  final bool tag;

  Hello({
    required this.id,
    required this.name,
    required this.tag,
  });
}

class HelloWorld {
  final int id;
  final Hello hello;

  HelloWorld({
    required this.id,
    required this.hello,
  });
}
