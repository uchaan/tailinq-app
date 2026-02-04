import '../../data/models/user.dart';

/// Authentication state
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  confirmationRequired,
}

/// Result of sign up operation
class SignUpResult {
  final bool isSignUpComplete;
  final String? userId;

  const SignUpResult({
    required this.isSignUpComplete,
    this.userId,
  });
}

/// Result of sign in operation
class SignInResult {
  final bool isSignedIn;
  final bool needsConfirmation;

  const SignInResult({
    required this.isSignedIn,
    this.needsConfirmation = false,
  });
}

/// Result of password reset initiation
class ResetPasswordResult {
  final bool isPasswordReset;
  final String? deliveryDestination;

  const ResetPasswordResult({
    required this.isPasswordReset,
    this.deliveryDestination,
  });
}

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Get the currently authenticated user
  Future<User?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<AuthStatus> get authStateChanges;

  /// Sign up a new user with email and password
  Future<SignUpResult> signUp({
    required String email,
    required String password,
  });

  /// Confirm sign up with verification code
  Future<bool> confirmSignUp({
    required String email,
    required String code,
  });

  /// Resend confirmation code to email
  Future<void> resendConfirmationCode({
    required String email,
  });

  /// Sign in with email and password
  Future<SignInResult> signIn({
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Initiate password reset flow
  Future<ResetPasswordResult> resetPassword({
    required String email,
  });

  /// Confirm password reset with verification code and new password
  Future<bool> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  // Social sign-in methods (to be implemented later)
  // Future<User> signInWithGoogle();
  // Future<User> signInWithApple();
}
