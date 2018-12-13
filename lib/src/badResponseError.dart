library bakalari.core.errors;

/// This error is thrown whenever library receives bad response from server,
/// be it wrong status code or response format.
class BadResponseError extends Error {
  /// Decription of error
  String errorMessage;

  /// Error trace
  StackTrace trace;

  /// Error constructor. Specify errorMessage as error description and trace (as `StackTrace.current`).
  BadResponseError(this.errorMessage, this.trace);

  /// Override toString() and return error message, newline, and trace.
  @override
  String toString() => errorMessage + " at\n" + trace.toString();
}
