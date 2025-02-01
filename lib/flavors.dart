enum Flavor {
  development,
  local,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'flutter_template dev';
      case Flavor.local:
        return 'flutter_template local';
      case Flavor.production:
        return 'flutter_template';
      default:
        return 'title';
    }
  }

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.development:
        // return 'http://localhost:3004';
        return 'http://192.168.0.112:3004';
      case Flavor.local:
        return 'http://localhost:8080';
      case Flavor.production:
        return 'https://example.com';
      default:
        return '';
    }
  }
}
