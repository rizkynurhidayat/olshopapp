import 'package:olshopapp/features/shop/domain/entities/product.dart';

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
    List<String> images = [];
    if (json['img_1'] != null) images.add(json['img_1']);
    if (json['img_2'] != null) images.add(json['img_2']);
    if (json['img_3'] != null) images.add(json['img_3']);

    return ProductModel(
      id: json['_id'] ?? '',
      title: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      description: json['description'] ?? '',
      category: json['categories'] ?? '',
      image: json['img_1'] ?? '',
      discountPrice: json['disc_price'] != null ? double.tryParse(json['disc_price'].toString()) : null,
      carouselImages: images,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      soldCount: int.tryParse(json['sold']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': title,
      'price': price.toString(),
      'description': description,
      'categories': category,
      'img_1': image,
      'disc_price': discountPrice?.toString(),
      'rating': rating.toString(),
      'sold': soldCount,
    };
  }
}
