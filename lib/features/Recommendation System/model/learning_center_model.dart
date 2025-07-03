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
      image: json['image'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      price: (json['price'] as String),
      address: json['address'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as String),
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
