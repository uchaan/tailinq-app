import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/auth_exceptions.dart';
import '../../data/models/user.dart';
import '../../data/repositories/cognito_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for the auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repository = CognitoAuthRepository();
  ref.onDispose(() => repository.dispose());
  return repository;
});

/// Auth state that holds current user and status
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  final bool isLoading;
  final String? pendingEmail;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.isLoading = false,
    this.pendingEmail,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool? isLoading,
    String? pendingEmail,
    bool clearError = false,
    bool clearUser = false,
    bool clearPendingEmail = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      error: clearError ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
      pendingEmail: clearPendingEmail ? null : (pendingEmail ?? this.pendingEmail),
    );
  }
}

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<AuthStatus>? _authStateSubscription;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _init();
  }

  void _init() {
    _authStateSubscription = _repository.authStateChanges.listen((status) {
      state = state.copyWith(status: status);
    });
    checkAuthStatus();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          clearUser: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signUp(email: email, password: password);
      state = state.copyWith(
        status: AuthStatus.confirmationRequired,
        pendingEmail: email,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> confirmSignUp({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.confirmSignUp(email: email, code: code);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearPendingEmail: true,
      );
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> resendConfirmationCode({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resendConfirmationCode(email: email);
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repository.signIn(email: email, password: password);
      if (result.needsConfirmation) {
        state = state.copyWith(
          status: AuthStatus.confirmationRequired,
          pendingEmail: email,
          isLoading: false,
        );
      } else if (result.isSignedIn) {
        final user = await _repository.getCurrentUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.signOut();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoading: false,
        clearUser: true,
        clearPendingEmail: true,
      );
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPassword(email: email);
      state = state.copyWith(
        pendingEmail: email,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> confirmResetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.confirmResetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      state = state.copyWith(
        isLoading: false,
        clearPendingEmail: true,
      );
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  Future<void> updateProfile({String? name}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.updateProfile(name: name);
      await checkAuthStatus();
    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
      rethrow;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});

/// Provider for current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

/// Provider to check if confirmation is required
final isConfirmationRequiredProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.confirmationRequired;
});
