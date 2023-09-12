// To parse this JSON data, do
//
//     final productVariantModel = productVariantModelFromJson(jsonString);

import 'dart:convert';

ProductVariantModel productVariantModelFromJson(String str) => ProductVariantModel.fromJson(json.decode(str));

List<ProductVariantModel> productVariantModelListFromJson(String str) => List<ProductVariantModel>.from(json.decode(str).map((x) => ProductVariantModel.fromJson(x)));

String productVariantModelToJson(List<ProductVariantModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductVariantModel {
  ProductVariantModel({
    this.id,
    this.productId,
    this.color,
    this.colorCode,
    this.imageUrl,
    this.quantity,
    this.sizes,
  });

  int? id;
  int? productId;
  String? color;
  String? colorCode;
  String? imageUrl;
  int? quantity;
  String? sizes;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) => ProductVariantModel(
    id: json["id"],
    productId: json["productId"],
    color: json["color"],
    colorCode: json["colorCode"],
    imageUrl: json["imageUrl"],
    quantity: json["quantity"],
    sizes: json["sizes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productId": productId,
    "color": color,
    "colorCode": colorCode,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "sizes": sizes,
  };


  Map<String, dynamic> toMap() => {
    "id": id,
    "productId": productId,
    "color": color,
    "colorCode": colorCode,
    "imageUrl": imageUrl,
    "quantity": quantity,
    "sizes": sizes,
  };

  @override
  String toString() {
    return 'ProductVariantModel{id: $id, productId: $productId, color: $color, colorCode: $colorCode, imageUrl: $imageUrl, quantity: $quantity, sizes: $sizes}';
  }
}
