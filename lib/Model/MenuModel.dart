import 'dart:convert';

import 'package:apparel_options/Model/ProductVariantModel.dart';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));
List<MenuModel> menuModelListFromJson(String str) =>
    List<MenuModel>.from(json.decode(str).map((x) => MenuModel.fromJson(x)));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  int id;
  String type;
  String price;
  String size;
  String imageUrl;
  String tagName;
  String description;
  String ratingFrequency;
  String cumulativeRating;
  String branch;
  String category;
  String menuItem;
  String likes;
  String organization;
  String publish;
  String quantity;
  String product;
  String brand;
  String manufacturer;
  String newArrival;
  List<ProductVariantModel> productVariants;


  MenuModel({
      this.id,
      this.type,
      this.price,
      this.size,
      this.imageUrl,
      this.tagName,
      this.description,
      this.ratingFrequency,
      this.cumulativeRating,
      this.branch,
      this.category,
      this.menuItem,
      this.likes,
      this.organization,
      this.publish,
      this.quantity,
      this.product,
      this.brand,
      this.manufacturer,
      this.newArrival,
      this.productVariants
  });

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
      'menuItem': menuItem,
      'organization': organization,
      'publish': publish,
      'quantity': quantity,
      'product': product,
      'productVariants':productVariants,
      'brand':brand,
      'manufacturer':manufacturer,
      'newArrival':newArrival,
    };
  }

  Map<String, dynamic> toJson() {

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
      'menuItem': menuItem,
      'organization': organization,
      'publish': publish,
      'quantity': quantity,
      'product': product,
      'productVariants':productVariants,
      'brand':brand,
      'manufacturer':manufacturer,
      'newArrival':newArrival,
    };
  }

  MenuModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        type = res["type"],
        price = res["price"],
        size = res["size"],
        imageUrl = res["imageUrl"],
        tagName = res["tagName"],
        description = res["description"],
        branch = res["branch"],
        cumulativeRating = res["cumulativeRating"],
        ratingFrequency = res["ratingFrequency"],
        category = res["category"],
        menuItem = res["menuItem"],
        likes = res["likes"],
        organization = res["organization"],
        publish = res["publish"],
        quantity = res["quantity"],
        product = res["product"],
        brand = res["brand"],
        manufacturer = res["manufacturer"],
        newArrival = res["newArrival"],

        productVariants = List<dynamic>.from(res["productVariants"].map((x) => x));
  //
  MenuModel.fromJson(Map<dynamic, dynamic> res)
      : id = res['id'],
        type = res["type"],
        price = res["price"],
        size = res["size"],
        imageUrl = res["imageUrl"],
        tagName = res["tagName"],
        description = res["description"],
        branch = res["branch"],
        cumulativeRating = res["cumulativeRating"],
        ratingFrequency = res["ratingFrequency"],
        category = res["category"],
        menuItem = res["menuItem"],
        likes = res["likes"],
        organization = res["organization"],
        publish = res["publish"],
        quantity = res["quantity"],
        product = res["product"],
        brand = res["brand"],
        manufacturer = res["manufacturer"],
        newArrival = res["newArrival"],
        productVariants =List<ProductVariantModel>.from(res["productVariants"].map((x) => x));

  @override
  String toString() {
    return 'MenuModel{id: $id, type: $type, price: $price, size: $size, imageUrl: $imageUrl, tagName: $tagName, description: $description, ratingFrequency: $ratingFrequency, cumulativeRating: $cumulativeRating, branch: $branch, category: $category, menuItem: $menuItem, likes: $likes, organization: $organization, publish: $publish, quantity: $quantity, product: $product, brand: $brand, manufacturer: $manufacturer, newArrival: $newArrival, productVariants: $productVariants}';
  }
}
