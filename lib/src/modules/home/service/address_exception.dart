class AddressException implements Exception {
  const AddressException(this.message);

  final String message;

  @override
  String toString() => message;
}
