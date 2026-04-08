// import 'package:equatable/equatable.dart';
// import 'package:hive/hive.dart';

// part 'product.g.dart';

// @HiveType(typeId: 1)
// class Product extends Equatable {
//   @HiveField(0)
//   final int id;
//   @HiveField(1)
//   final String title;
//   @HiveField(2)
//   final double price;
//   @HiveField(3)
//   final String description;
//   @HiveField(4)
//   final String category;
//   @HiveField(5)
//   final String image;
//   @HiveField(6)
//   final double? discountPrice;
//   @HiveField(7)
//   final List<String> carouselImages;
//   @HiveField(8)
//   final double rating;
//   @HiveField(9)
//   final int soldCount;

//   const Product({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.category,
//     required this.image,
//     this.discountPrice,
//     this.carouselImages = const [],
//     this.rating = 0.0,
//     this.soldCount = 0,
//   });

//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         price,
//         description,
//         category,
//         image,
//         discountPrice,
//         carouselImages,
//         rating,
//         soldCount,
//       ];
// }


import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final String image;
  @HiveField(6)
  final double? discountPrice;
  @HiveField(7)
  final List<String> carouselImages;
  @HiveField(8)
  final double rating;
  @HiveField(9)
  final int soldCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.discountPrice,
    this.carouselImages = const [],
    this.rating = 0.0,
    this.soldCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        category,
        image,
        discountPrice,
        carouselImages,
        rating,
        soldCount,
      ];
}
