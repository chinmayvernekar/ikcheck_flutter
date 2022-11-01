class SignUp {
  final String password;
  final String email;
  final String firstName;
  final String lastName;

  const SignUp({required this.password, required this.email,required this.firstName,required this.lastName});

  factory SignUp.fromJson(Map<String, dynamic> json) {
    return SignUp(
      password: json['password'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],

    );
  }
}
