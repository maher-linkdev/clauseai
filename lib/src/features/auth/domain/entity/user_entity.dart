import 'package:flutter/foundation.dart';

@immutable
class UserEntity {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool isAnonymous;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  const UserEntity({
    required this.id,
    this.email,
    this.displayName,
    this.photoURL,
    required this.isAnonymous,
    this.createdAt,
    this.lastSignInAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    bool? isAnonymous,
    DateTime? createdAt,
    DateTime? lastSignInAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.isAnonymous == isAnonymous &&
        other.createdAt == createdAt &&
        other.lastSignInAt == lastSignInAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      email,
      displayName,
      photoURL,
      isAnonymous,
      createdAt,
      lastSignInAt,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, displayName: $displayName, '
        'photoURL: $photoURL, isAnonymous: $isAnonymous, '
        'createdAt: $createdAt, lastSignInAt: $lastSignInAt)';
  }
}
