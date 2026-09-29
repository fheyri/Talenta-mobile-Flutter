class AppUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isProfileComplete;
  final int tokenBalance;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isProfileComplete,
    required this.tokenBalance,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      isProfileComplete: json['is_profile_complete'] == true,
      tokenBalance: (json['token_balance'] as num?)?.toInt() ?? 0,
    );
  }
}
