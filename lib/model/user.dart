class User {
  final String userName;
  final String userCpf;
  final String userEmail;
  final String userCell;
  final String password;
  final DateTime birthdate;
  final bool isSubscriber;
  final bool isNutritious;
  List<String> diets;
  List<String> adresses;
  List<String> feedbacks;

  User({
    required this.userName,
    required this.userCpf,
    required this.userEmail,
    required this.userCell,
    required this.password,
    required this.birthdate,
    required this.isSubscriber,
    required this.isNutritious,
    this.adresses = const [],
    this.diets = const [],
    this.feedbacks = const [],
  });
}
