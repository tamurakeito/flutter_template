class Result<T, E> {
  final T? data;
  final E? error;

  Result({this.data, this.error});

  // bool get isSuccess => data != null && error == null;
}
