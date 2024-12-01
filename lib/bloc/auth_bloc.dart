import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_onAuthLoginRequested);
    on<LogoutEventRequested>(_onLogoutRequested);
  }
  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print('Change - $change');
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final email = event.email;
      final password = event.password;
      final emailRegEx = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
      );

      if (password.length < 5) {
        emit(AuthFailure(message: 'Password must be at least 5 characters long'));
        return;
      }

      if (!emailRegEx.hasMatch(email)) {
        emit(AuthFailure(message: 'Invalid email'));
        return;
      }

      await Future.delayed(const Duration(seconds: 1));
      emit(AuthSuccess(uid: '$email-$password'));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutEventRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
