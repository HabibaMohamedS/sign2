class UserModel {
  final String username;
  final String email;
  final String password;

  final String government;
  final String address;
  final String phoneNumber;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.government,
    required this.address,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      government: json['government'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'government': government,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}
