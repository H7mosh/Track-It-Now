import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part  'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  // Check authentication status
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isAuthenticated = await _authRepository.isAuthenticated();

      if (isAuthenticated) {
        final user = await _authRepository.getCurrentUser();

        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Sign in user
  Future<void> signIn(String nameUser, String password) async {
    emit(AuthLoading());

    final response = await _authRepository.signIn(nameUser, password);

    if (response.success && response.data != null) {
      emit(AuthAuthenticated(response.data!));
    } else {
      emit(AuthError(response.error ?? 'ناوی بەکارهێنەر یان وشەی نهێنی هەڵەیە'));
    }
  }

  // Sign out user
  Future<void> signOut() async {
    emit(AuthLoading());

    await _authRepository.signOut();

    emit(AuthUnauthenticated());
  }
}