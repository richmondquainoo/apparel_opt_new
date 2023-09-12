class OTPModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  int? pin;

  OTPModel({
    this.id,
    this.name,
    this.email,
    this.pin,
    this.phone,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'email': email,
      'pin': pin,
      'phone': phone,
      'password': password,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'email': email,
      'pin': pin,
      'phone': phone,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'OTPModel{id: $id, name: $name, email: $email, phone: $phone, password: $password, pin: $pin}';
  }
}
