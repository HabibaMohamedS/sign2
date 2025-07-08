class LearningCenter {
  final String image;
  final String name;
  final String price;
  final String phone;
  final String address;
  final String description;
  final String rating;

  LearningCenter({
    required this.phone,
    required this.image,
    required this.name,
    required this.price,
    required this.address,
    required this.description,
    required this.rating,
  });

  factory LearningCenter.fromJson(Map<String, dynamic> json) {
    return LearningCenter(
      image: json['image'] ?? '',
      phone: json['phone'] ?? "",
      name: json['name'] ?? "",
      price: json['price'] ?? "",
      address: json['address'] ?? "",
      description: json['description'] ?? "",
      rating: json['rating'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'address': address,
      'description': description,
      'rating': rating,
    };
  }
}
