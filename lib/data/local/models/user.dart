class User {
  final String nick;
  final String email;

  const User({
    required this.nick,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nick: json['nick'],
      email: json['email'],
    );
  }
}
