// To parse this JSON data, do
//
//     final newMenuModel = newMenuModelFromJson(jsonString);

import 'dart:convert';

import 'package:apparel_options/Model/ProductVariantModel.dart';

NewMenuModel newMenuModelFromJson(String str) => NewMenuModel.fromJson(json.decode(str));
List<NewMenuModel> newMenuModelListFromJson(String str) => List<NewMenuModel>.from(json.decode(str).map((x) => NewMenuModel.fromJson(x)));


String newMenuModelToJson(NewMenuModel data) => json.encode(data.toJson());

class NewMenuModel {
  NewMenuModel({
    this.id,
    this.organization,
    this.product,
    this.category,
    this.type,
    this.tagName,
    this.imageUrl,
    this.price,
    this.size,
    this.createdBy,
    this.createOn,
    this.lastUpdated,
    this.lastUpdatedBy,
    this.likes,
    this.cumulativeRating,
    this.ratingFrequency,
    this.branch,
    this.description,
    this.publish,
    this.productVariants,
  });

  dynamic id;
  String organization;
  String product;
  String category;
  String type;
  String tagName;
  String imageUrl;
  dynamic price;
  String size;
  dynamic createdBy;
  DateTime createOn;
  DateTime lastUpdated;
  dynamic lastUpdatedBy;
  dynamic likes;
  dynamic cumulativeRating;
  dynamic ratingFrequency;
  String branch;
  String description;
  bool publish;
  List<ProductVariant> productVariants;

  factory NewMenuModel.fromJson(Map<String, dynamic> json) => NewMenuModel(
    id: json["id"],
    organization: json["organization"],
    product: json["product"],
    category: json["category"],
    type: json["type"],
    tagName: json["tagName"],
    imageUrl: json["imageUrl"],
    price: json["price"],
    size: json["size"],
    createdBy: json["createdBy"],
    createOn: DateTime.parse(json["createOn"]),
    lastUpdated: DateTime.parse(json["lastUpdated"]),
    lastUpdatedBy: json["lastUpdatedBy"],
    likes: json["likes"],
    cumulativeRating: json["cumulativeRating"],
    ratingFrequency: json["ratingFrequency"],
    branch: json["branch"],
    description: json["description"],
    publish: json["publish"],
    productVariants: List<ProductVariant>.from(json["productVariants"].map((x) => ProductVariant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organization": organization,
    "product": product,
    "category": category,
    "type": type,
    "tagName": tagName,
    "imageUrl": imageUrl,
    "price": price,
    "size": size,
    "createdBy": createdBy,
    "createOn": createOn.toIso8601String(),
    "lastUpdated": lastUpdated.toIso8601String(),
    "lastUpdatedBy": lastUpdatedBy,
    "likes": likes,
    "cumulativeRating": cumulativeRating,
    "ratingFrequency": ratingFrequency,
    "branch": branch,
    "description": description,
    "publish": publish,
    "productVariants": List<ProductVariantModel>.from(productVariants.map((x) => x.toJson())),
  };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'size': size,
      'imageUrl': imageUrl,
      'tagName': tagName,
      'description': description,
      'branch': branch,
      'cumulativeRating': cumulativeRating,
      'ratingFrequency': ratingFrequency,
      'category': category,
      'organization': organization,
      'publish': publish,
      'product': product,
      'productVariants':productVariants,
    };
  }

}

class ProductVariant {
  ProductVariant({
    this.id,
    this.productId,
    this.color,
    this.colorCode,
    this.imageUrl,
    this.quantity,
    this.sizes,
  });

  dynamic id;
  dynamic productId;
  String color;
  String colorCode;
  String imageUrl;
  dynamic quantity;
  String sizes;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
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
}
