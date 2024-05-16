import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iqj/features/auth/models/user_permissions.dart';

class AppUser {
  final String userUID;
  final String name;
  final String surname;
  final String patronymic;
  final String login;
  final Timestamp birthday;
  final String email;
  final String phone;
  final String userPlatform;
  final String role;
  final String profilePicture;
  final bool? isReceivingMessagesDisabled;
  final bool? isBirthdayVisible;
  final bool? isPhoneVisible;
  final bool? isEmailVisible;
  final UserPermissions? userPermissions;
  final bool? isVerified;
  final List<String> blocked;

  AppUser({
    required this.userUID,
    required this.name,
    required this.surname,
    required this.patronymic,
    required this.login,
    required this.birthday,
    required this.email,
    required this.phone,
    required this.userPlatform,
    required this.role,
    required this.profilePicture,
    this.isReceivingMessagesDisabled,
    this.isBirthdayVisible,
    this.isPhoneVisible,
    this.isEmailVisible,
    this.userPermissions,
    this.isVerified = false,
    required this.blocked
  });
}