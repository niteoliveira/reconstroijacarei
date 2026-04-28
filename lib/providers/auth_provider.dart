import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Modelo mock do usuário
class AppUser {
  final String id;
  final String name;
  final String email;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
  });
}

/// Provider de autenticação (mock por enquanto)
final authProvider =
    StateNotifierProvider<AuthNotifier, AppUser?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier()
      : super(const AppUser(
          id: 'user-001',
          name: 'Leonardo Oliveira',
          email: 'leonardo@email.com',
        ));

  /// Logout — limpa o usuário
  void logout() {
    state = null;
  }

  /// Login mock
  void login({
    String id = 'user-001',
    String name = 'Leonardo Oliveira',
    String email = 'leonardo@email.com',
  }) {
    state = AppUser(id: id, name: name, email: email);
  }
}
