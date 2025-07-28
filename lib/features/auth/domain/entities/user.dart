// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? picture;
  final String? accessToken;
  final String? refreshToken;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.picture,
    required this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props =>
      [id, email, name, picture, accessToken, refreshToken];
}
