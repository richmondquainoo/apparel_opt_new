class UserModel {
  String username;
  String email;
  String password;
  String firstname;
  String lastname;
  String phone;
  int pin;

  UserModel(
      {this.username,
      this.email,
      this.password,
      this.lastname,
      this.firstname,
      this.pin,
      this.phone});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'lastname': lastname,
      'firstname': firstname,
      'pin': pin
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'lastname': lastname,
      'firstname': firstname,
      'pin': pin
    };
  }

  @override
  String toString() {
    return 'UserModel{phone: $phone, username: $username, email: $email, password: $password, firstname: $firstname, lastname: $lastname, pin: $pin}';
  }
}
