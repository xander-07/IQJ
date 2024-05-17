class Response {
  final bool isSuccess;
  final String message;
  final int code;

  Response({
    required this.isSuccess,
    required this.message,
    required this.code,
  });
}