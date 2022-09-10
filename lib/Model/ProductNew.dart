import 'package:flutter/material.dart';

class ProductNew {
  final int id;
  final String brand;
  final String title, description;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  ProductNew({
    this.brand,
    @required this.id,
    @required this.images,
    @required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    @required this.title,
    @required this.price,
    @required this.description,
  });
}

// Our demo Products

List<ProductNew> demoProducts = [
  ProductNew(
    id: 1,
    images: [
      "https://www.alphabroder.com/prodimg/large/g200_66_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g200_49_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g200_25_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g200_26_p.jpg",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Gildan Adult Ultra Cotton®",
    price: 64.99,
    brand: "Gildan",
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
  ),
  ProductNew(
    id: 2,
    images: [
      "https://www.alphabroder.com/prodimg/large/562_62_p.jpg",
      "https://www.alphabroder.com/prodimg/large/562_52_p.jpg",
      "https://www.alphabroder.com/prodimg/large/562_dc_p.jpg",
      "https://www.alphabroder.com/prodimg/large/562_56_p.jpg",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.amber,
    ],
    title: "Jerzees Adult NuBlend® ",
    price: 50.5,
    brand: "Gildan",
    description: description,
    rating: 4.1,
    isPopular: true,
  ),
  ProductNew(
    id: 3,
    images: [
      "https://www.alphabroder.com/prodimg/large/5250t_31_p.jpg",
      "https://www.alphabroder.com/prodimg/large/5250t_15_p.jpg",
      "https://www.alphabroder.com/prodimg/large/5250t_32_p.jpg",
      "https://www.alphabroder.com/prodimg/large/5250t_54_p.jpg",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Hanes Men's Authentic-T ",
    price: 36.55,
    brand: "Gildan",
    description: description,
    rating: 4.1,
    isFavourite: true,
    isPopular: true,
  ),
  ProductNew(
    id: 4,
    images: [
      "https://www.alphabroder.com/prodimg/large/g64v_51_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g64v_16_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g64v_ba_p.jpg",
      "https://www.alphabroder.com/prodimg/large/g64v_33_p.jpg",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Cotton V-Neck",
    price: 20.20,
    brand: "Gildan",
    description: description,
    rating: 4.1,
    isFavourite: true,
  ),
];

const String description = "Cotton Tees available for all in different colors";
