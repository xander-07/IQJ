class User {
  final String uid;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final String displayName;
  final String phoneNumber;
  final DateTime lastSignInTime;
  final DateTime creationTime;
  User({
    required this.uid,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
    required this.displayName,
    required this.phoneNumber,
    required this.lastSignInTime,
    required this.creationTime,
  });
}
