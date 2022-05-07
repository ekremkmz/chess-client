enum FailureKey {
  unknown,
  requestFailure,
  storagePermissionDenied,
}

class Failure {
  final FailureKey key;
  final String message;

  const Failure({
    required this.key,
    required this.message,
  });
}
