import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    super.discountPrice,
    super.carouselImages,
    super.rating,
    super.soldCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handling rating from fakestoreapi structure
    double ratingValue = 0.0;
    int countValue = 0;
    if (json['rating'] != null) {
      ratingValue = (json['rating']['rate'] as num).toDouble();
      countValue = (json['rating']['count'] as num).toInt();
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      discountPrice: json['discountPrice'] != null ? (json['discountPrice'] as num).toDouble() : null,
      carouselImages: json['carouselImages'] != null ? List<String>.from(json['carouselImages']) : [],
      rating: json['rating_val'] != null ? (json['rating_val'] as num).toDouble() : ratingValue,
      soldCount: json['soldCount'] != null ? (json['soldCount'] as num).toInt() : countValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'discountPrice': discountPrice,
      'carouselImages': carouselImages,
      'rating_val': rating,
      'soldCount': soldCount,
    };
  }
}
