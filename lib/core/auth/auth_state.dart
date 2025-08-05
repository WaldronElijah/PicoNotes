import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'auth_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AuthState()) {
    // Delay initialization to ensure Supabase is ready
    Future.microtask(() => _init());
  }

  void _init() {
    try {
      // Listen to auth state changes
      _authService.authStateChanges.listen((authState) {
        if (authState.event == AuthChangeEvent.signedIn) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: authState.session?.user,
          );
        } else if (authState.event == AuthChangeEvent.signedOut) {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        }
      });

      // Check initial auth state
      if (_authService.isSignedIn) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: _authService.currentUser,
        );
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      // If there's an error during initialization, set to unauthenticated
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: 'Initialization error: $e',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
} 