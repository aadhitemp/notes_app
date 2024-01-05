import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable //it tells that it and it's subclass don't change after creation
class AuthUser {
  final String id;
  final String email; //we made email not optional
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.isEmailVerified,
    required this.email,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid, //added this line to find unique id of user in firebase
        email: user
            .email!, //explicitly unwrap it with ! after making email non nullable
        isEmailVerified: user.emailVerified,
      );
}
