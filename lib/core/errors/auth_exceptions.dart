/// Base class for authentication exceptions
sealed class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message';
}

/// Thrown when user credentials are invalid
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String message = 'Invalid email or password'])
      : super(message, code: 'INVALID_CREDENTIALS');
}

/// Thrown when user is not found
class UserNotFoundException extends AuthException {
  const UserNotFoundException([String message = 'User not found'])
      : super(message, code: 'USER_NOT_FOUND');
}

/// Thrown when email is already in use
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException([String message = 'Email already in use'])
      : super(message, code: 'EMAIL_ALREADY_IN_USE');
}

/// Thrown when password does not meet requirements
class WeakPasswordException extends AuthException {
  const WeakPasswordException([String message = 'Password is too weak'])
      : super(message, code: 'WEAK_PASSWORD');
}

/// Thrown when confirmation code is invalid
class InvalidConfirmationCodeException extends AuthException {
  const InvalidConfirmationCodeException([String message = 'Invalid confirmation code'])
      : super(message, code: 'INVALID_CODE');
}

/// Thrown when confirmation code has expired
class CodeExpiredException extends AuthException {
  const CodeExpiredException([String message = 'Confirmation code has expired'])
      : super(message, code: 'CODE_EXPIRED');
}

/// Thrown when user is not confirmed (email not verified)
class UserNotConfirmedException extends AuthException {
  const UserNotConfirmedException([String message = 'Email not verified'])
      : super(message, code: 'USER_NOT_CONFIRMED');
}

/// Thrown when too many requests are made
class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([String message = 'Too many requests. Please try again later.'])
      : super(message, code: 'TOO_MANY_REQUESTS');
}

/// Thrown when network is unavailable
class NetworkException extends AuthException {
  const NetworkException([String message = 'Network error. Please check your connection.'])
      : super(message, code: 'NETWORK_ERROR');
}

/// Thrown for unknown authentication errors
class UnknownAuthException extends AuthException {
  const UnknownAuthException([String message = 'An unknown error occurred'])
      : super(message, code: 'UNKNOWN');
}

/// Thrown when user session has expired
class SessionExpiredException extends AuthException {
  const SessionExpiredException([String message = 'Session has expired. Please sign in again.'])
      : super(message, code: 'SESSION_EXPIRED');
}

/// Thrown when password reset limit is exceeded
class PasswordResetLimitException extends AuthException {
  const PasswordResetLimitException([String message = 'Password reset limit exceeded. Please try again later.'])
      : super(message, code: 'PASSWORD_RESET_LIMIT');
}
