class UpdateQueryException implements Exception {
  final message;
  
  /// UPDATE query must have at least 1 optional parameter 
  UpdateQueryException([this.message]);

  String toString() {
    if (message == null) return "Exception: \"UPDATE query must have at least 1 optional parameter\"";
    return "Exception: $message";
  }
}