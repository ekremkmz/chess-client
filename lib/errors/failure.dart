enum FailureKey {
  unknown,
  requestFailure,
  storagePermissionDenied,
  socketConnectionError,
}

class Failure {
  final FailureKey key;
  final String message;

  const Failure({
    required this.key,
    required this.message,
  });
}
