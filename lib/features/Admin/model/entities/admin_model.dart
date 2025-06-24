class AdminModel {
  String adminID;
  String password;
  AdminModel({
    required this.adminID,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
      'adminID': adminID,
      'password': password,
    };
  }
  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      adminID: json['adminID'] as String,
      password: json['password'] as String,
    );
  }
}
