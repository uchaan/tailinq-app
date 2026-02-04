import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;

import '../../core/errors/auth_exceptions.dart' as auth_errors;
import '../../domain/repositories/auth_repository.dart';
import '../models/user.dart';

/// Implementation of AuthRepository using AWS Cognito via Amplify
class CognitoAuthRepository implements AuthRepository {
  final _authStateController = StreamController<AuthStatus>.broadcast();

  CognitoAuthRepository() {
    _initAuthStateListener();
  }

  void _initAuthStateListener() {
    amplify.Amplify.Hub.listen(amplify.HubChannel.Auth, (event) {
      switch (event.type) {
        case amplify.AuthHubEventType.signedIn:
          _authStateController.add(AuthStatus.authenticated);
          break;
        case amplify.AuthHubEventType.signedOut:
          _authStateController.add(AuthStatus.unauthenticated);
          break;
        case amplify.AuthHubEventType.sessionExpired:
          _authStateController.add(AuthStatus.unauthenticated);
          break;
        case amplify.AuthHubEventType.userDeleted:
          _authStateController.add(AuthStatus.unauthenticated);
          break;
      }
    });
  }

  @override
  Stream<AuthStatus> get authStateChanges => _authStateController.stream;

  @override
  Future<User?> getCurrentUser() async {
    try {
      final session = await amplify.Amplify.Auth.fetchAuthSession();
      if (!session.isSignedIn) {
        return null;
      }

      final attributes = await amplify.Amplify.Auth.fetchUserAttributes();
      String? email;
      String? sub;
      bool emailVerified = false;

      for (final attr in attributes) {
        switch (attr.userAttributeKey.key) {
          case 'email':
            email = attr.value;
            break;
          case 'sub':
            sub = attr.value;
            break;
          case 'email_verified':
            emailVerified = attr.value.toLowerCase() == 'true';
            break;
        }
      }

      if (email == null || sub == null) {
        return null;
      }

      return User(
        id: sub,
        email: email,
        emailVerified: emailVerified,
      );
    } on amplify.AuthException {
      return null;
    }
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final result = await amplify.Amplify.Auth.signUp(
        username: email,
        password: password,
        options: amplify.SignUpOptions(
          userAttributes: {
            amplify.AuthUserAttributeKey.email: email,
          },
        ),
      );

      return SignUpResult(
        isSignUpComplete: result.isSignUpComplete,
        userId: result.userId,
      );
    } on cognito.UsernameExistsException {
      throw const auth_errors.EmailAlreadyInUseException();
    } on cognito.InvalidPasswordException catch (e) {
      throw auth_errors.WeakPasswordException(e.message);
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<bool> confirmSignUp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await amplify.Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );
      return result.isSignUpComplete;
    } on cognito.CodeMismatchException {
      throw const auth_errors.InvalidConfirmationCodeException();
    } on cognito.ExpiredCodeException {
      throw const auth_errors.CodeExpiredException();
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<void> resendConfirmationCode({
    required String email,
  }) async {
    try {
      await amplify.Amplify.Auth.resendSignUpCode(username: email);
    } on cognito.LimitExceededException {
      throw const auth_errors.TooManyRequestsException();
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign out first to clear any previous session
      try {
        await amplify.Amplify.Auth.signOut();
      } catch (_) {
        // Ignore sign out errors
      }

      final result = await amplify.Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.nextStep.signInStep == amplify.AuthSignInStep.confirmSignUp) {
        _authStateController.add(AuthStatus.confirmationRequired);
        return const SignInResult(
          isSignedIn: false,
          needsConfirmation: true,
        );
      }

      if (result.isSignedIn) {
        _authStateController.add(AuthStatus.authenticated);
      }

      return SignInResult(isSignedIn: result.isSignedIn);
    } on cognito.UserNotFoundException {
      throw const auth_errors.UserNotFoundException();
    } on cognito.NotAuthorizedServiceException {
      throw const auth_errors.InvalidCredentialsException();
    } on cognito.UserNotConfirmedException {
      _authStateController.add(AuthStatus.confirmationRequired);
      return const SignInResult(
        isSignedIn: false,
        needsConfirmation: true,
      );
    } on cognito.LimitExceededException {
      throw const auth_errors.TooManyRequestsException();
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await amplify.Amplify.Auth.signOut();
      _authStateController.add(AuthStatus.unauthenticated);
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<ResetPasswordResult> resetPassword({
    required String email,
  }) async {
    try {
      final result = await amplify.Amplify.Auth.resetPassword(username: email);

      String? destination;
      final deliveryDetails = result.nextStep.codeDeliveryDetails;
      if (deliveryDetails != null) {
        destination = deliveryDetails.destination;
      }

      return ResetPasswordResult(
        isPasswordReset: result.isPasswordReset,
        deliveryDestination: destination,
      );
    } on cognito.UserNotFoundException {
      throw const auth_errors.UserNotFoundException();
    } on cognito.LimitExceededException {
      throw const auth_errors.PasswordResetLimitException();
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  @override
  Future<bool> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final result = await amplify.Amplify.Auth.confirmResetPassword(
        username: email,
        newPassword: newPassword,
        confirmationCode: code,
      );
      return result.isPasswordReset;
    } on cognito.CodeMismatchException {
      throw const auth_errors.InvalidConfirmationCodeException();
    } on cognito.ExpiredCodeException {
      throw const auth_errors.CodeExpiredException();
    } on cognito.InvalidPasswordException catch (e) {
      throw auth_errors.WeakPasswordException(e.message);
    } on amplify.AuthException catch (e) {
      throw auth_errors.UnknownAuthException(e.message);
    }
  }

  void dispose() {
    _authStateController.close();
  }
}
