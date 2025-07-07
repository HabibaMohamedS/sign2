import 'package:sign2/support/theme/app_images.dart';

class UserModel {
  final String username;
  final String email;
  final String password;

  final String government;
  final String address;
  final String phoneNumber;
  String? imageUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.government,
    required this.address,
    required this.phoneNumber,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      government: json['government'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'] ?? AppImages.defaultAvatar, // Default avatar if not provided
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
      'imageUrl': imageUrl ?? AppImages.defaultAvatar, // Ensure imageUrl is never null
    };
  }

UserModel copyWith({
    String? username,
    String? government,
    String? address,
    String? phoneNumber,
    String? imageUrl,
  }) =>
      UserModel(
        username: username ?? this.username,
        email: email,               // immutable
        password: password,
        government: government ?? this.government,
        address: address ?? this.address,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        imageUrl: imageUrl ?? this.imageUrl,
      );
}
