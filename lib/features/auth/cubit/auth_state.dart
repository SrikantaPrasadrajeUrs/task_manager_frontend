part of "auth_cubit.dart";

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignUp extends AuthState {}

final class AuthFailure extends AuthState {}