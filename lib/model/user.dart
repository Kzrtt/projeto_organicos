class User {
  final int userId;
  final String userName;
  final String userEmail;
  final String userCpf;
  final String password;
  final bool isSubscriber;
  final bool isNutritious;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userCpf,
    required this.password,
    required this.isSubscriber,
    required this.isNutritious,
  });
}
