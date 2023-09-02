import 'package:chatx/data/models/user.dart';
import 'package:chatx/data/services/auth_service.dart';
import 'package:response_x/response_x.dart';

abstract class AuthRepository {
  Future<Response> signUp({required User user});
  Future<Response> signIn({required User user});
}

class AuthRepositoryOf implements AuthRepository {
  const AuthRepositoryOf({required this.service});
  final AuthService service;
  @override
  Future<Response> signUp({required User user}) => service.signUp(user: user);

  @override
  Future<Response> signIn({required User user}) => service.signIn(user: user);
}
